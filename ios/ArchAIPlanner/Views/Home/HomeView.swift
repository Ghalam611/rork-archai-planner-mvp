//
//  HomeView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct HomeView: View {
    @Bindable var appState: AppState
    @State private var appearedIndices: Set<Int> = []
    @State private var pulse: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                AnimatedAuroraLayer()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.xl) {
                        // Dashboard Header
                        SmoothTransition {
                            DashboardHeader(name: appState.userName, projectCount: appState.projects.count, pulse: pulse)
                        }
                        
                        // AI Studio Section
                        VStack(spacing: Theme.Spacing.lg) {
                            SectionLabel(title: "AI Studio", caption: "Tap a module to begin")
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: Theme.Spacing.md),
                                GridItem(.flexible(), spacing: Theme.Spacing.md)
                            ], spacing: Theme.Spacing.md) {
                                ForEach(Array(DashboardFeature.all.enumerated()), id: \.element.id) { index, feature in
                                    NavigationLink(value: feature.id) {
                                        PremiumDashboardCard(feature: feature, index: index)
                                    }
                                    .buttonStyle(.plain)
                                    .opacity(appearedIndices.contains(index) ? 1 : 0)
                                    .offset(y: appearedIndices.contains(index) ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: appearedIndices)
                                    .onTapGesture {
                                        HapticFeedbackManager.shared.selection()
                                    }
                                }
                            }
                        }
                        
                        // Recent Projects
                        if !appState.projects.isEmpty {
                            VStack(spacing: Theme.Spacing.lg) {
                                SectionLabel(title: "Recent concepts", caption: "Continue where you left off")
                                
                                VStack(spacing: Theme.Spacing.md) {
                                    ForEach(appState.projects.prefix(2)) { project in
                                        PremiumProjectCard(project: project)
                                    }
                                }
                            }
                        }
                    }
                    .padding(Theme.Spacing.lg)
                    .padding(.bottom, Theme.Spacing.xxl)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .generate: CreateDesignView(appState: appState)
                case .voice: SilentDesignerView(appState: appState)
                case .land: EmptyLandVisionView(appState: appState)
                case .cultural: CulturalArchitectureView()
                case .redesign: ReDesignView(appState: appState)
                case .saved: GalleryView(projects: appState.projects)
                case .chat: ChatView(appState: appState)
                }
            }
            .onAppear {
                pulse = true
                for i in DashboardFeature.all.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                        appearedIndices.insert(i)
                    }
                }
            }
        }
    }
}

struct DashboardHeader: View {
    let name: String
    let projectCount: Int
    let pulse: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Status Bar
            HStack(spacing: Theme.Spacing.sm) {
                PulsingView {
                    HStack(spacing: Theme.Spacing.xs) {
                        Circle()
                            .fill(Theme.saudiGold)
                            .frame(width: 8, height: 8)
                        Text("ARCHAI · ONLINE")
                            .font(Theme.Typography.caption2)
                            .fontWeight(.bold)
                            .tracking(2.4)
                            .foregroundStyle(Theme.saudiGold)
                    }
                }
                
                Spacer()
                
                Text("v1.0")
                    .font(Theme.Typography.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textTertiary)
            }
            
            // Welcome Section
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Welcome,")
                    .font(Theme.Typography.title3)
                    .foregroundStyle(Theme.textSecondary)
                
                Text(name)
                    .font(Theme.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Design futuristic spaces with AI as your co-architect.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stats Cards
            HStack(spacing: Theme.Spacing.md) {
                MetricCard(icon: "square.stack.3d.up.fill", value: "\(projectCount)", label: "Projects")
                MetricCard(icon: "sparkles", value: "6", label: "AI Modules")
                MetricCard(icon: "bolt.fill", value: "Live", label: "Engine")
            }
        }
    }
}

struct MetricCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        GlassCard {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.saudiGold)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(value)
                        .font(Theme.Typography.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text(label)
                        .font(Theme.Typography.caption2)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct PremiumDashboardCard: View {
    let feature: DashboardFeature
    let index: Int
    @State private var shimmer: Bool = false
    @State private var isPressed = false

    var body: some View {
        FeatureCard(accentColor: feature.accent.first ?? Theme.primary, shadowColor: Theme.Shadow.gold) {
            VStack(spacing: Theme.Spacing.md) {
                // Icon and Tag
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(feature.accent.first?.opacity(0.2) ?? Theme.primary.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: feature.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(feature.accent.first ?? Theme.primary)
                    }
                    
                    Spacer()
                    
                    Text(feature.tag)
                        .font(Theme.Typography.caption2)
                        .fontWeight(.heavy)
                        .tracking(1.2)
                        .foregroundStyle(Theme.background)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                .fill(feature.accent.first ?? Theme.primary)
                        )
                }
                
                // Content
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(feature.title)
                        .font(Theme.Typography.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(feature.subtitle)
                        .font(Theme.Typography.caption1)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Shimmer Effect
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(shimmer ? 2.5 : 0.5)
                    .offset(x: shimmer ? 200 : -200)
                    .opacity(0.6)
                    .clipped()
            }
            .padding(Theme.Spacing.lg)
            .frame(height: 140)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
        .onAppear {
            shimmer = true
        }
    }
}

struct PremiumProjectCard: View {
    let project: DesignProject
    @State private var isVisible = false

    var body: some View {
        PremiumCard(shadowColor: Theme.Shadow.card) {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text(project.title)
                            .font(Theme.Typography.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("\(project.landSize) • \(project.floors) floors • \(project.bedrooms) bedrooms")
                            .font(Theme.Typography.caption1)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    IconButton("chevron.right", style: .ghost) {
                        HapticFeedbackManager.shared.selection()
                    }
                }
                
                Text(project.result.styleDescription)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}
