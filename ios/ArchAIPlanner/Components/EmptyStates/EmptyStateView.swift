//
//  EmptyStateView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            PulsingView {
                Image(systemName: icon)
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(Theme.saudiGold.opacity(0.7))
            }
            
            VStack(spacing: Theme.Spacing.sm) {
                Text(title)
                    .font(Theme.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            if let actionTitle = actionTitle, let action = action {
                ModernButton(actionTitle, style: .secondary, action: action)
                    .padding(.top, Theme.Spacing.sm)
            }
        }
        .padding(Theme.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Theme.border,
                                    Theme.saudiGold.opacity(0.2),
                                    Theme.border
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

// MARK: - Predefined Empty States
extension EmptyStateView {
    static let noProjects = EmptyStateView(
        icon: "square.stack.3d.up",
        title: "No Projects Yet",
        subtitle: "Start creating your first architectural concept with AI assistance",
        actionTitle: "Create First Project",
        action: nil // Will be set in context
    )
    
    static let noMessages = EmptyStateView(
        icon: "bubble.left.and.text.bubble.right",
        title: "Start a Conversation",
        subtitle: "Ask our AI architect about design concepts, layouts, or architectural advice",
        actionTitle: "Ask a Question",
        action: nil // Will be set in context
    )
    
    static let noSavedDesigns = EmptyStateView(
        icon: "heart.square",
        title: "No Saved Designs",
        subtitle: "Your favorite architectural concepts will appear here for quick access",
        actionTitle: "Browse Gallery",
        action: nil // Will be set in context
    )
    
    static let networkError = EmptyStateView(
        icon: "wifi.slash",
        title: "Connection Lost",
        subtitle: "Please check your internet connection and try again",
        actionTitle: "Retry",
        action: nil // Will be set in context
    )
    
    static let comingSoon = EmptyStateView(
        icon: "sparkles.rectangle.stack",
        title: "Feature Coming Soon",
        subtitle: "We're working on this amazing feature. Stay tuned for updates!",
        actionTitle: "Get Notified",
        action: nil // Will be set in context
    )
}
