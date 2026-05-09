//
//  AnimatedAuroraLayer.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct AnimatedAuroraLayer: View {
    @State private var animate: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.gold.opacity(0.22))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: animate ? 140 : 80, y: animate ? -300 : -260)
            Circle()
                .fill(Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.16))
                .frame(width: 280, height: 280)
                .blur(radius: 100)
                .offset(x: animate ? -160 : -100, y: animate ? 120 : 200)
            Circle()
                .fill(Color(red: 1.0, green: 0.4, blue: 0.6).opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 90)
                .offset(x: animate ? 100 : 40, y: animate ? 360 : 320)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
