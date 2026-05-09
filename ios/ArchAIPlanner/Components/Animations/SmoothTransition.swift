//
//  SmoothTransition.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct SmoothTransition<Content: View>: View {
    let content: Content
    let animation: Animation
    @State private var isVisible = false
    
    init(
        animation: Animation = .spring(response: 0.6, dampingFraction: 0.8),
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.animation = animation
    }
    
    var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(animation, value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

struct SlideInFromBottom<Content: View>: View {
    let content: Content
    @State private var isVisible = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(y: isVisible ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(response: 0.5, dampingFraction: 0.9), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

struct FadeInScale<Content: View>: View {
    let content: Content
    let delay: Double
    @State private var isVisible = false
    
    init(delay: Double = 0, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.delay = delay
    }
    
    var body: some View {
        content
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

struct StaggeredAnimation<Content: View>: View {
    let content: Content
    let baseDelay: Double
    let staggerDelay: Double
    @State private var isVisible = false
    
    init(
        baseDelay: Double = 0,
        staggerDelay: Double = 0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.baseDelay = baseDelay
        self.staggerDelay = staggerDelay
    }
    
    var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 30)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(baseDelay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}
