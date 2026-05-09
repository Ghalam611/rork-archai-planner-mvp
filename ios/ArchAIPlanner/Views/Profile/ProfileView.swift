//
//  ProfileView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack(alignment: .leading, spacing: 18) {
                HeaderBlock(title: "Profile", subtitle: "Account, Supabase sync, and studio preferences.")
                VStack(alignment: .leading, spacing: 14) {
                    Label(appState.userName, systemImage: "person.crop.circle.fill")
                    Label("Supabase auth ready", systemImage: "checkmark.seal.fill")
                    Label("OpenAI endpoints scaffolded", systemImage: "brain.head.profile")
                    Label("Expo Go requested; native Rork preview currently uses Swift", systemImage: "iphone")
                }
                .foregroundStyle(.white.opacity(0.86))
                .padding(18)
                .background(.white.opacity(0.07), in: .rect(cornerRadius: 24))
                Button("Sign out") {
                    appState.isAuthenticated = false
                }
                .buttonStyle(GoldButtonStyle())
                Spacer()
            }
            .padding(20)
        }
    }
}
