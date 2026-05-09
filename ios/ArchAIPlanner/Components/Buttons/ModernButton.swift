//
//  ModernButton.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ModernButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
        _ title: String,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.textColor))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(style.font)
                    .fontWeight(style.fontWeight)
            }
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, style.verticalPadding)
            .padding(.horizontal, style.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(style.border, lineWidth: style.borderWidth)
                    )
            )
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 0.95 : 1.0)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDisabled)
        .sensoryFeedback(.selection, trigger: isLoading ? false : true)
    }
    
    enum ButtonStyle {
        case primary, secondary, outline, ghost
        
        var font: Font {
            switch self {
            case .primary, .secondary: return Theme.Typography.headline
            case .outline, .ghost: return Theme.Typography.subheadline
            }
        }
        
        var fontWeight: Font.Weight {
            switch self {
            case .primary, .secondary: return .semibold
            case .outline, .ghost: return .medium
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary: return Theme.background
            case .secondary: return Theme.textPrimary
            case .outline: return Theme.primary
            case .ghost: return Theme.textSecondary
            }
        }
        
        var background: AnyShapeStyle {
            switch self {
            case .primary: return AnyShapeStyle(Theme.goldGradient)
            case .secondary: return AnyShapeStyle(Theme.surfaceLight)
            case .outline: return AnyShapeStyle(Color.clear)
            case .ghost: return AnyShapeStyle(Color.clear)
            }
        }
        
        var border: Color {
            switch self {
            case .primary: return Color.clear
            case .secondary: return Theme.border
            case .outline: return Theme.primary
            case .ghost: return Color.clear
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .primary: return 0
            case .secondary: return 1
            case .outline: return 1.5
            case .ghost: return 0
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .primary: return Theme.CornerRadius.large
            case .secondary, .outline, .ghost: return Theme.CornerRadius.medium
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .primary: return Theme.Spacing.md
            case .secondary, .outline, .ghost: return Theme.Spacing.sm
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .primary: return Theme.Spacing.lg
            case .secondary, .outline, .ghost: return Theme.Spacing.md
            }
        }
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    let style: IconButtonStyle
    let size: CGFloat
    
    init(
        _ icon: String,
        style: IconButtonStyle = .primary,
        size: CGFloat = 44,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundColor(style.textColor)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(style.background)
                        .overlay(
                            Circle()
                                .stroke(style.border, lineWidth: style.borderWidth)
                        )
                )
        }
        .sensoryFeedback(.selection, trigger: true)
    }
    
    enum IconButtonStyle {
        case primary, secondary, ghost
        
        var textColor: Color {
            switch self {
            case .primary: return Theme.background
            case .secondary: return Theme.textPrimary
            case .ghost: return Theme.textSecondary
            }
        }
        
        var background: AnyShapeStyle {
            switch self {
            case .primary: return AnyShapeStyle(Theme.goldGradient)
            case .secondary: return AnyShapeStyle(Theme.surfaceLight)
            case .ghost: return AnyShapeStyle(Color.clear)
            }
        }
        
        var border: Color {
            switch self {
            case .primary: return Color.clear
            case .secondary: return Theme.border
            case .ghost: return Color.clear
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .primary: return 0
            case .secondary: return 1
            case .ghost: return 0
            }
        }
    }
}
