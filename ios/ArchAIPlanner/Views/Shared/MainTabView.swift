//
//  MainTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct MainTabView: View {
    @Bindable var appState: AppState

    var body: some View {
        TabView {
            HomeView(appState: appState)
                .tabItem { Label("Home", systemImage: "square.grid.2x2") }
            NavigationStack {
                CreateDesignView(appState: appState)
            }
            .tabItem { Label("Create", systemImage: "wand.and.stars") }
            NavigationStack {
                ChatView(appState: appState)
            }
            .tabItem { Label("Chat", systemImage: "bubble.left.and.text.bubble.right") }
            ProfileView(appState: appState)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(Theme.gold)
        .preferredColorScheme(.dark)
    }
}
