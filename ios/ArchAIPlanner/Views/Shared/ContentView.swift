//
//  ContentView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = AppState()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                if showSplash {
                    SplashView()
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Group {
                        if appState.isAuthenticated {
                            MainTabView(appState: appState)
                        } else {
                            AuthFlowView(appState: appState)
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            PulsingView {
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundStyle(Theme.saudiGold)
            }
            
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
            
            Text("Luxury Architecture Design")
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.textSecondary)
                .tracking(2)
        }
        .scaleEffect(isAnimating ? 1.0 : 0.8)
        .opacity(isAnimating ? 1.0 : 0)
        .animation(.spring(response: 1.0, dampingFraction: 0.7), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview Providers
#Preview("Default") {
    ContentView()
}

#Preview("Authenticated") {
    ContentView()
        .with(MockData.authenticatedAppState)
}

#Preview("Unauthenticated") {
    ContentView()
        .with(MockData.unauthenticatedAppState)
}

#Preview("iPhone 15 Pro") {
    ContentView()
        .previewDevice(PreviewDevices.iPhone15Pro.name)
}

#Preview("iPhone 15 Pro Max") {
    ContentView()
        .previewDevice(PreviewDevices.iPhone15ProMax.name)
}

#Preview("iPad Pro") {
    ContentView()
        .previewDevice(PreviewDevices.iPadPro.name)
}

// MARK: - Preview Helper
extension ContentView {
    func with(_ appState: AppState) -> some View {
        var view = self
        view._appState = State(initialValue: appState)
        return view
    }
}
