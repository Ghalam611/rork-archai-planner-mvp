//
//  LoadingStatesView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

/// Comprehensive loading states and error handling for AI operations
struct LoadingStatesView: View {
    let state: LoadingState
    let onRetry: (() -> Void)?
    
    var body: some View {
        switch state {
        case .idle:
            EmptyView()
            
        case .loading(let message):
            LoadingView(message: message)
            
        case .success(let message):
            SuccessView(message: message)
            
        case .error(let error, let retryable):
            ErrorView(error: error, retryable: retryable, onRetry: onRetry)
        }
    }
}

// MARK: - Loading State Enum
enum LoadingState: Equatable {
    case idle
    case loading(message: String)
    case success(message: String)
    case error(error: Error, retryable: Bool)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let error, _) = self {
            return error.localizedDescription
        }
        return nil
    }
}

// MARK: - Loading View
struct LoadingView: View {
    let message: String
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Animated Loading Indicator
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
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(Theme.background)
                    .rotationEffect(.degrees(Double(animationPhase * 36)))
                    .scaleEffect(1.0 + Double(animationPhase) * 0.1)
            }
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    animationPhase = 10
                }
            }
            
            // Loading Message
            VStack(spacing: Theme.Spacing.sm) {
                Text("AI is Working")
                    .font(Theme.Typography.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textPrimary)
                
                Text(message)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Progress Dots
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Theme.saudiGold)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.0)
                            .opacity(0.3)
                            .animation(
                                .easeInOut(duration: 1.0)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: UUID()
                            )
                    }
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
    }
}

// MARK: - Success View
struct SuccessView: View {
    let message: String
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Success Animation
            ZStack {
                Circle()
                    .fill(Theme.accentEmerald.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(Theme.accentEmerald.opacity(0.5), lineWidth: 2)
                    )
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Theme.accentEmerald)
                    .scaleEffect(showCheckmark ? 1.0 : 0.5)
                    .opacity(showCheckmark ? 1.0 : 0.0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showCheckmark = true
                }
            }
            
            // Success Message
            VStack(spacing: Theme.Spacing.sm) {
                Text("Success!")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.accentEmerald)
                
                Text(message)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .padding(Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                        .stroke(Theme.accentEmerald.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Error View
struct ErrorView: View {
    let error: Error
    let retryable: Bool
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Error Icon
            ZStack {
                Circle()
                    .fill(Theme.accentCopper.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(Theme.accentCopper.opacity(0.5), lineWidth: 2)
                    )
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Theme.accentCopper)
            }
            
            // Error Message
            VStack(spacing: Theme.Spacing.md) {
                Text("Something went wrong")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.accentCopper)
                
                Text(error.localizedDescription)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Retry Button
                if retryable && onRetry != nil {
                    ModernButton("Try Again", style: .primary) {
                        onRetry?()
                        HapticFeedback.shared.medium()
                    }
                }
            }
            
            // Error Details (for development)
            #if DEBUG
            VStack(spacing: Theme.Spacing.sm) {
                Text("Error Details")
                    .font(Theme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textTertiary)
                
                Text(String(describing: error))
                    .font(Theme.Typography.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .fill(Theme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                    )
            }
            #endif
        }
        .padding(Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                        .stroke(Theme.accentCopper.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Network Status View
struct NetworkStatusView: View {
    let status: NetworkStatus
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Status Icon
            Image(systemName: status.icon)
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(status.color)
            
            // Status Message
            VStack(spacing: Theme.Spacing.md) {
                Text(status.title)
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(status.color)
                
                Text(status.description)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Retry Button
                if status.canRetry && onRetry != nil {
                    ModernButton("Retry", style: .primary) {
                        onRetry?()
                        HapticFeedback.shared.medium()
                    }
                }
            }
        }
        .padding(Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                        .stroke(status.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Network Status Enum
enum NetworkStatus {
    case connected
    case disconnected
    case connecting
    case error(Error)
    
    var icon: String {
        switch self {
        case .connected:
            return "wifi"
        case .disconnected:
            return "wifi.slash"
        case .connecting:
            return "wifi"
        case .error:
            return "exclamationmark.wifi"
        }
    }
    
    var color: Color {
        switch self {
        case .connected:
            return Theme.accentEmerald
        case .disconnected:
            return Theme.accentCopper
        case .connecting:
            return Theme.saudiGold
        case .error:
            return Theme.richMaroon
        }
    }
    
    var title: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .error:
            return "Connection Error"
        }
    }
    
    var description: String {
        switch self {
        case .connected:
            return "Your app is connected to the AI services"
        case .disconnected:
            return "Please check your internet connection"
        case .connecting:
            return "Establishing connection to AI services..."
        case .error(let error):
            return error.localizedDescription
        }
    }
    
    var canRetry: Bool {
        switch self {
        case .connected, .connecting:
            return false
        case .disconnected, .error:
            return true
        }
    }
}

// MARK: - API Configuration Status View
struct APIConfigurationStatusView: View {
    let configStatus: ConfigurationStatus
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                // Header
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: configStatus.isValid ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(configStatus.isValid ? Theme.accentEmerald : Theme.accentCopper)
                    
                    Text("API Configuration")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Status Message
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    HStack {
                        Text("Status:")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.textSecondary)
                        
                        Text(configStatus.statusMessage)
                            .font(Theme.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(statusColor)
                    }
                    
                    if !configStatus.issues.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Issues found:")
                                .font(Theme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundStyle(Theme.accentCopper)
                            
                            ForEach(configStatus.issues, id: \.self) { issue in
                                HStack(spacing: Theme.Spacing.xs) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 8))
                                        .foregroundStyle(Theme.accentCopper)
                                    
                                    Text(issue)
                                        .font(Theme.Typography.caption2)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                        .padding(Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(Theme.accentCopper.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Theme.accentCopper.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Demo Mode Notice
                    if configStatus.isDemoMode {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            HStack(spacing: Theme.Spacing.sm) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Theme.accentAmber)
                                
                                Text("Demo Mode Active")
                                    .font(Theme.Typography.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.accentAmber)
                            }
                            
                            Text("The app is running in demo mode with limited functionality. Configure your API keys to enable full AI features.")
                                .font(Theme.Typography.caption1)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(2)
                        }
                        .padding(Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(Theme.accentAmber.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Theme.accentAmber.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
    
    private var statusColor: Color {
        switch configStatus.statusColor {
        case "green":
            return Theme.accentEmerald
        case "orange":
            return Theme.accentAmber
        case "red":
            return Theme.accentCopper
        default:
            return Theme.textSecondary
        }
    }
}

// MARK: - Preview
#Preview("Loading State") {
    VStack(spacing: Theme.Spacing.lg) {
        LoadingStatesView(state: .loading("Generating architecture design..."))
        
        LoadingStatesView(state: .success("Project saved successfully!"))
        
        LoadingStatesView(state: .error(NSError(domain: "test", code: 500), retryable: true)) {
            print("Retry tapped")
        }
    }
    .padding()
    .background(Theme.background)
}

#Preview("Network Status") {
    VStack(spacing: Theme.Spacing.lg) {
        NetworkStatusView(status: .connected) { }
        NetworkStatusView(status: .disconnected) { }
        NetworkStatusView(status: .connecting) { }
        NetworkStatusView(status: .error(NSError(domain: "test", code: 500))) { }
    }
    .padding()
    .background(Theme.background)
}

#Preview("API Configuration Status") {
    ScrollView {
        VStack(spacing: Theme.Spacing.lg) {
            APIConfigurationStatusView(configStatus: ConfigurationStatus(
                isValid: false,
                isDemoMode: true,
                issues: ["OpenAI API key is missing", "Supabase configuration is missing"]
            ))
            
            APIConfigurationStatusView(configStatus: ConfigurationStatus(
                isValid: true,
                isDemoMode: false,
                issues: []
            ))
        }
        .padding()
    }
    .background(Theme.background)
}
