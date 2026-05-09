//
//  LuxuryLoadingView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryLoadingView: View {
    let message: String
    let progress: Double
    let showProgress: Bool
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var isAnimating = false
    
    init(message: String = "Creating architectural masterpiece...", progress: Double = 0.5, showProgress: Bool = false) {
        self.message = message
        self.progress = progress
        self.showProgress = showProgress
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Animated Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.royalGold.opacity(0.8),
                                Theme.saudiGold.opacity(0.6),
                                Theme.antiqueGold.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(Theme.royalGold.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(
                        color: Theme.Shadow.royalGold,
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(Theme.background)
                    .rotationEffect(.degrees(rotation))
            }
            .scaleEffect(pulseScale)
            .onAppear {
                startAnimations()
            }
            .onDisappear {
                stopAnimations()
            }
            
            // Loading Message
            VStack(spacing: Theme.Spacing.sm) {
                Text(message)
                    .font(Theme.Typography.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .shimmerEffect(isAnimating: true, direction: .leftToRight)
                
                if showProgress {
                    VStack(spacing: Theme.Spacing.xs) {
                        Text("Progress")
                            .font(Theme.Typography.caption1)
                            .fontWeight(.medium)
                            .foregroundStyle(Theme.textSecondary)
                        
                        ProgressView(value: progress)
                            .progressViewStyle(
                                LinearProgressViewStyle(tint: Theme.royalGold, trackColor: Theme.surfaceLight)
                            )
                            .scaleEffect(y: 2.0)
                    }
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(Theme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                    )
                }
            }
        }
        .padding(Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Theme.royalGold.opacity(0.4),
                                    Theme.saudiGold.opacity(0.3),
                                    Theme.royalGold.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private func startAnimations() {
        isAnimating = true
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.05
        }
    }
    
    private func stopAnimations() {
        isAnimating = false
        withAnimation(.easeInOut(duration: 0.3)) {
            rotation = 0
            pulseScale = 1.0
        }
    }
}

struct ElegantLoadingCard: View {
    @State private var shimmerOffset: CGFloat = -200
    @State private var opacity: Double = 0.8
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack(spacing: Theme.Spacing.sm) {
                ShimmerView(width: 40, height: 40, cornerRadius: 20)
                
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    ShimmerView(width: 120, height: 16)
                    ShimmerView(width: 80, height: 12)
                }
                
                Spacer()
            }
            
            HStack(spacing: Theme.Spacing.sm) {
                ShimmerView(width: 60, height: 14)
                ShimmerView(width: 100, height: 14)
                ShimmerView(width: 140, height: 14)
                Spacer()
            }
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
        .opacity(opacity)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: opacity)
    }
}

// MARK: - Preview Providers
#Preview("Luxury Loading") {
    LuxuryLoadingView(
        message: "Designing your dream architecture...",
        progress: 0.75,
        showProgress: true
    )
    .padding()
    .background(Theme.background)
}

#Preview("Simple Loading") {
    LuxuryLoadingView(
        message: "Generating design concepts...",
        showProgress: false
    )
    .padding()
    .background(Theme.background)
}

#Preview("Loading Cards") {
    VStack(spacing: Theme.Spacing.lg) {
        ElegantLoadingCard()
        ElegantLoadingCard()
            .opacity(0.8)
    }
    .padding()
    .background(Theme.background)
}
