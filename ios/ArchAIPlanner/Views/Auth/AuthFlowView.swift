//
//  AuthFlowView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct AuthFlowView: View {
    @Bindable var appState: AppState
    @State private var isSignup: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var isAnimating = false
    @State private var showContent = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    Spacer(minLength: Theme.Spacing.xl)
                    
                    // Header Section
                    VStack(spacing: Theme.Spacing.lg) {
                        FadeInScale(delay: 0) {
                            VStack(spacing: Theme.Spacing.sm) {
                                Text("ArchAI")
                                    .font(Theme.Typography.largeTitle)
                                    .fontWeight(.black)
                                    .foregroundStyle(Theme.saudiGoldGradient)
                                
                                Text("Planner")
                                    .font(Theme.Typography.title1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.textPrimary)
                            }
                        }
                        
                        FadeInScale(delay: 0.2) {
                            Text("Generate architectural concepts, early layouts, room distributions, and refined villa ideas with AI.")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                    }
                    
                    // Auth Form
                    PremiumCard(shadowColor: Theme.Shadow.gold, shadowRadius: 20) {
                        VStack(spacing: Theme.Spacing.lg) {
                            if isSignup {
                                StaggeredAnimation(baseDelay: 0.3) {
                                    ModernTextField("Full name", text: $name, icon: "person")
                                }
                            }
                            
                            StaggeredAnimation(baseDelay: 0.4) {
                                ModernTextField("Email", text: $email, icon: "envelope", keyboardType: .emailAddress)
                            }
                            
                            StaggeredAnimation(baseDelay: 0.5) {
                                ModernTextField("Password", text: $password, icon: "lock", isSecure: true)
                            }
                            
                            StaggeredAnimation(baseDelay: 0.6) {
                                ModernButton(
                                    isSignup ? "Create account" : "Enter studio",
                                    style: .primary,
                                    isLoading: isAnimating
                                ) {
                                    authenticate()
                                }
                            }
                            
                            StaggeredAnimation(baseDelay: 0.7) {
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        isSignup.toggle()
                                    }
                                    HapticFeedbackManager.shared.selection()
                                } label: {
                                    Text(isSignup ? "Already have an account? Login" : "New here? Create an account")
                                        .font(Theme.Typography.callout)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Theme.saudiGold)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                }
                .padding(.vertical, Theme.Spacing.xl)
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            showContent = true
        }
    }
    
    private func authenticate() {
        isAnimating = true
        HapticFeedbackManager.shared.medium()
        
        // Simulate authentication delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            appState.userName = name.isEmpty ? "Founder" : name
            appState.isAuthenticated = true
            HapticFeedbackManager.shared.success()
            isAnimating = false
        }
    }
}
