//
//  LuxuryBackground.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 0.05, green: 0.045, blue: 0.035), Color(red: 0.11, green: 0.085, blue: 0.045)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(Theme.gold.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: 130, y: -260)
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 220, height: 220)
                .blur(radius: 70)
                .offset(x: -130, y: 230)
        }
        .ignoresSafeArea()
    }
}
