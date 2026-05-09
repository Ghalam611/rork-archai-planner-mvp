//
//  LuxuryAnimations.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryEntranceAnimation: ViewModifier {
    let isAnimating: Bool
    let delay: Double
    
    init(isAnimating: Bool, delay: Double = 0) {
        self.isAnimating = isAnimating
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1 : 0)
            .rotationEffect(.degrees(isAnimating ? 0 : 5))
            .animation(
                .spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.5)
                .delay(delay),
                value: isAnimating
            )
    }
}

struct ShimmerEffect: ViewModifier {
    let isAnimating: Bool
    let direction: ShimmerDirection
    
    enum ShimmerDirection {
        case leftToRight, rightToLeft, topToBottom, bottomToTop
    }
    
    init(isAnimating: Bool, direction: ShimmerDirection = .leftToRight) {
        self.isAnimating = isAnimating
        self.direction = direction
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: gradientStartPoint,
                            endPoint: gradientEndPoint
                        )
                    )
                    .scaleEffect(isAnimating ? 1.5 : 0.5)
                    .offset(gradientOffset)
            )
            .clipped()
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
    
    private var gradientStartPoint: UnitPoint {
        switch direction {
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        case .topToBottom: return .top
        case .bottomToTop: return .bottom
        }
    }
    
    private var gradientEndPoint: UnitPoint {
        switch direction {
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        case .topToBottom: return .bottom
        case .bottomToTop: return .top
        }
    }
    
    private var gradientOffset: CGSize {
        let distance: CGFloat = 200
        switch direction {
        case .leftToRight: return isAnimating ? CGSize(width: distance, height: 0) : CGSize(width: -distance, height: 0)
        case .rightToLeft: return isAnimating ? CGSize(width: -distance, height: 0) : CGSize(width: distance, height: 0)
        case .topToBottom: return isAnimating ? CGSize(width: 0, height: distance) : CGSize(width: 0, height: -distance)
        case .bottomToTop: return isAnimating ? CGSize(width: 0, height: -distance) : CGSize(width: 0, height: distance)
        }
    }
}

struct FloatingAnimation: ViewModifier {
    let isAnimating: Bool
    let amplitude: CGFloat
    let frequency: Double
    @State private var animationPhase: Double = 0
    
    init(isAnimating: Bool, amplitude: CGFloat = 8, frequency: Double = 2.0) {
        self.isAnimating = isAnimating
        self.amplitude = amplitude
        self.frequency = frequency
    }
    
    func body(content: Content) -> some View {
        content
            .offset(
                y: isAnimating ? amplitude * sin(animationPhase) : 0
            )
            .onAppear {
                if isAnimating {
                    withAnimation(.linear(duration: 1.0 / frequency).repeatForever(autoreverses: false)) {
                        animationPhase = .pi * 2
                    }
                }
            }
            .onChange(of: isAnimating) { newValue in
                if newValue {
                    withAnimation(.linear(duration: 1.0 / frequency).repeatForever(autoreverses: false)) {
                        animationPhase = .pi * 2
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animationPhase = 0
                    }
                }
            }
    }
}

struct PulseGlowEffect: ViewModifier {
    let isPulsing: Bool
    let glowColor: Color
    
    init(isPulsing: Bool, glowColor: Color = Theme.royalGold) {
        self.isPulsing = isPulsing
        self.glowColor = glowColor
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: isPulsing ? glowColor.opacity(0.6) : glowColor.opacity(0.3),
                radius: isPulsing ? 20 : 10
            )
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isPulsing
            )
    }
}

// MARK: - View Extensions
extension View {
    func luxuryEntrance(isAnimating: Bool, delay: Double = 0) -> some View {
        modifier(LuxuryEntranceAnimation(isAnimating: isAnimating, delay: delay))
    }
    
    func shimmerEffect(isAnimating: Bool, direction: ShimmerEffect.ShimmerDirection = .leftToRight) -> some View {
        modifier(ShimmerEffect(isAnimating: isAnimating, direction: direction))
    }
    
    func floatingAnimation(isAnimating: Bool, amplitude: CGFloat = 8, frequency: Double = 2.0) -> some View {
        modifier(FloatingAnimation(isAnimating: isAnimating, amplitude: amplitude, frequency: frequency))
    }
    
    func pulseGlow(isPulsing: Bool, glowColor: Color = Theme.royalGold) -> some View {
        modifier(PulseGlowEffect(isPulsing: isPulsing, glowColor: glowColor))
    }
}

// MARK: - Preview Providers
#Preview("Shimmer Effect") {
    VStack(spacing: Theme.Spacing.lg) {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
            .fill(Theme.surface)
            .frame(width: 200, height: 60)
            .shimmerEffect(isAnimating: true)
        
        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
            .fill(Theme.surface)
            .frame(width: 200, height: 60)
            .shimmerEffect(isAnimating: true, direction: .topToBottom)
    }
    .padding()
    .background(Theme.background)
}

#Preview("Floating Animation") {
    VStack(spacing: Theme.Spacing.xl) {
        HStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 24))
                .foregroundStyle(Theme.royalGold)
                .floatingAnimation(isAnimating: true)
            
            Image(systemName: "crown.fill")
                .font(.system(size: 24))
                .foregroundStyle(Theme.saudiGold)
                .floatingAnimation(isAnimating: true, amplitude: 6, frequency: 1.5)
        }
    }
    .padding()
    .background(Theme.background)
}

#Preview("Pulse Glow") {
    VStack(spacing: Theme.Spacing.xl) {
        Image(systemName: "sparkles")
            .font(.system(size: 40))
            .foregroundStyle(Theme.royalGold)
            .pulseGlow(isPulsing: true)
        
        Image(systemName: "heart.fill")
            .font(.system(size: 40))
            .foregroundStyle(Theme.accentCopper)
            .pulseGlow(isPulsing: true, glowColor: Theme.accentCopper)
    }
    .padding()
    .background(Theme.background)
}
