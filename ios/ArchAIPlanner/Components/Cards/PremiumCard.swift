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
    let cornerRadius: CGFloat
    let backgroundColor: AnyShapeStyle
    let borderColor: Color
    let borderWidth: CGFloat
    
    init(
        padding: CGFloat = Theme.Spacing.lg,
        shadowColor: Color = Theme.Shadow.premium,
        shadowRadius: CGFloat = 16,
        cornerRadius: CGFloat = Theme.CornerRadius.xxlarge,
        backgroundColor: AnyShapeStyle = AnyShapeStyle(Theme.luxuryCardGradient),
        borderColor: Color = Theme.border,
        borderWidth: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Theme.royalGold.opacity(0.3),
                                        Theme.saudiGold.opacity(0.2),
                                        Theme.royalGold.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: borderWidth
                            )
                    )
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: 12
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
