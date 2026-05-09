//
//  EmptyLandVisionView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct EmptyLandVisionView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack {
                HeaderBlock(title: "Empty Land Vision", subtitle: "Capture a land photo. AI overlays a concept building.")
                Spacer()
                Text("Camera and AR interface coming soon")
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Land Vision")
        .navigationBarTitleDisplayMode(.inline)
    }
}
