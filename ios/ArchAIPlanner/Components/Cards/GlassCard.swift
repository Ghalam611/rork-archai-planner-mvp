//
//  GlassCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    init(
        padding: CGFloat = Theme.Spacing.md,
        cornerRadius: CGFloat = Theme.CornerRadius.large,
        shadowColor: Color = Theme.Shadow.glass,
        shadowRadius: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
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
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Preview Providers
#Preview("Default Glass Card") {
    GlassCard {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Theme.royalGold)
            
            Text("Glass Morphism")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
    .padding()
    .background(Theme.backgroundGradient)
}

#Preview("Glass Card with Content") {
    GlassCard {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Premium Feature")
                .font(Theme.Typography.title3)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
            
            Text("Experience the luxury of glassmorphic design with premium materials and elegant animations.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
        }
    }
    .padding()
    .background(Theme.backgroundGradient)
}

#Preview("Glass Card Button") {
    GlassCard {
        ModernButton("Premium Action", style: .primary) {
            print("Glass card button tapped")
        }
    }
    .padding()
    .background(Theme.backgroundGradient)
}
