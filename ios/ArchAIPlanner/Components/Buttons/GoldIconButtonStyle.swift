//
//  GoldIconButtonStyle.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct GoldIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.black)
            .background(Theme.goldGradient, in: .circle)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
    }
}
