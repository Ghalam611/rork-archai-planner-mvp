//
//  PremiumCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct PremiumCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    init(
        padding: CGFloat = Theme.Spacing.lg,
        shadowColor: Color = Theme.Shadow.card,
        shadowRadius: CGFloat = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                    .fill(Theme.luxuryCardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: 8
            )
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    
    init(padding: CGFloat = Theme.Spacing.md, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            )
    }
}

struct FeatureCard<Content: View>: View {
    let content: Content
    let accentColor: Color
    let shadowColor: Color
    
    init(
        accentColor: Color = Theme.primary,
        shadowColor: Color = Theme.Shadow.gold,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.accentColor = accentColor
        self.shadowColor = shadowColor
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentColor.opacity(0.15),
                                accentColor.opacity(0.08),
                                accentColor.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                            .stroke(accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(
                color: shadowColor,
                radius: 20,
                x: 0,
                y: 12
            )
    }
}

// MARK: - Preview Providers
#Preview("Premium Card") {
    PremiumCard {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Premium Card Title")
                .font(Theme.Typography.headline)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
            
            Text("This is a premium card with luxury styling, shadows, and elegant design elements.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.leading)
        }
    }
    .padding()
    .background(Theme.background)
}

#Preview("Glass Card") {
    GlassCard {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 24))
                .foregroundStyle(Theme.saudiGold)
            
            Text("Glass Morphism")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
        }
    }
    .padding()
    .background(Theme.backgroundGradient)
}

#Preview("Feature Card") {
    FeatureCard(accentColor: Theme.accentEmerald, shadowColor: Theme.Shadow.gold) {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "sparkles")
                .font(.system(size: 32))
                .foregroundStyle(Theme.accentEmerald)
            
            Text("Feature Highlight")
                .font(Theme.Typography.title3)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(height: 120)
    }
    .padding()
    .background(Theme.background)
}
