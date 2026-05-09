//
//  ShimmerView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    let gradient: LinearGradient
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        width: CGFloat = 200,
        height: CGFloat = 20,
        cornerRadius: CGFloat = Theme.CornerRadius.small,
        gradient: LinearGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.05),
                Color.white.opacity(0.15),
                Color.white.opacity(0.05)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.gradient = gradient
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(gradient)
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.5 : 0.5)
                    .offset(x: isAnimating ? width : -width)
            )
            .clipped()
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

struct LoadingCardView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                ShimmerView(width: 40, height: 40, cornerRadius: 20)
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    ShimmerView(width: 120, height: 16)
                    ShimmerView(width: 80, height: 12)
                }
                Spacer()
            }
            
            ShimmerView(width: .infinity, height: 14, cornerRadius: Theme.CornerRadius.small)
            ShimmerView(width: .infinity, height: 14, cornerRadius: Theme.CornerRadius.small)
            ShimmerView(width: 200, height: 14, cornerRadius: Theme.CornerRadius.small)
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
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct PulsingView<Content: View>: View {
    let content: Content
    @State private var isPulsing = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}
