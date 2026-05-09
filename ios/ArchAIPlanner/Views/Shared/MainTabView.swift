//
//  MainTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct MainTabView: View {
    @Bindable var appState: AppState
    @State private var selectedTab: TabItem = .home

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main Content
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        HomeView(appState: appState)
                    }
                    .tag(TabItem.home)
                    
                    NavigationStack {
                        CreateDesignView(appState: appState)
                    }
                    .tag(TabItem.create)
                    
                    NavigationStack {
                        ChatView(appState: appState)
                    }
                    .tag(TabItem.chat)
                    
                    NavigationStack {
                        ProfileView(appState: appState)
                    }
                    .tag(TabItem.profile)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
                
                // Modern Tab Bar
                VStack(spacing: 0) {
                    Divider()
                        .overlay(Theme.border)
                    
                    ModernTabBar(selectedTab: $selectedTab)
                }
                .background(.ultraThinMaterial)
            }
        }
        .preferredColorScheme(.dark)
    }
}
