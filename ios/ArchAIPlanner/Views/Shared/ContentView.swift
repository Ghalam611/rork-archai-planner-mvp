//
//  ContentView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = AppState()

    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView(appState: appState)
            } else {
                AuthFlowView(appState: appState)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
