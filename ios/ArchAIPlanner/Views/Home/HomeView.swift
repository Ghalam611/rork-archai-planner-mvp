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
                LuxuryBackground()
                AnimatedAuroraLayer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        DashboardHeader(name: appState.userName, projectCount: appState.projects.count, pulse: pulse)

                        SectionLabel(title: "AI Studio", caption: "Tap a module to begin")

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                            ForEach(Array(DashboardFeature.all.enumerated()), id: \.element.id) { index, feature in
                                NavigationLink(value: feature.id) {
                                    DashboardCard(feature: feature, index: index)
                                }
                                .buttonStyle(.plain)
                                .opacity(appearedIndices.contains(index) ? 1 : 0)
                                .offset(y: appearedIndices.contains(index) ? 0 : 24)
                                .animation(.spring(response: 0.55, dampingFraction: 0.82).delay(Double(index) * 0.07), value: appearedIndices)
                            }
                        }

                        if !appState.projects.isEmpty {
                            SectionLabel(title: "Recent concepts", caption: "Continue where you left off")
                            ForEach(appState.projects.prefix(2)) { project in
                                ProjectCard(project: project)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
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
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(0.18))
                        .frame(width: 10, height: 10)
                        .scaleEffect(pulse ? 2.6 : 1)
                        .opacity(pulse ? 0 : 1)
                        .animation(.easeOut(duration: 1.6).repeatForever(autoreverses: false), value: pulse)
                    Circle()
                        .fill(Theme.gold)
                        .frame(width: 7, height: 7)
                }
                Text("ARCHAI · ONLINE")
                    .font(.caption2.weight(.bold))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                Spacer()
                Text("v1.0")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome,")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.55))
                Text(name)
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                Text("Design futuristic spaces with AI as your co-architect.")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.62))
                    .lineSpacing(2)
            }

            HStack(spacing: 10) {
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
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.gold)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.05), in: .rect(cornerRadius: 14))
        .overlay(.white.opacity(0.08), in: .rect(cornerRadius: 14).stroke(lineWidth: 1))
    }
}
