//
//  SilentDesignerView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct SilentDesignerView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack {
                HeaderBlock(title: "Silent Designer", subtitle: "Voice to architecture. Speak your dream building.")
                Spacer()
                Text("Voice recording interface coming soon")
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Voice Design")
        .navigationBarTitleDisplayMode(.inline)
    }
}
