//
//  TogglePill.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct TogglePill: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .tint(Theme.gold)
            .foregroundStyle(.white)
            .padding(14)
            .background(.white.opacity(0.07), in: .rect(cornerRadius: 18))
    }
}
