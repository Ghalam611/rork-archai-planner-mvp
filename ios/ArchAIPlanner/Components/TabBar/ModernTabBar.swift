//
//  ModernTabBar.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ModernTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var tabPositions: [CGRect] = []
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(selectedTab == tab ? Theme.background : Theme.textTertiary)
                            
                            Text(tab.title)
                                .font(Theme.Typography.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(selectedTab == tab ? Theme.background : Theme.textTertiary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                .fill(selectedTab == tab ? Theme.saudiGold : Color.clear)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                        )
                    }
                    .buttonStyle(.plain)
                    .background(
                        TabPositionReader(index: TabItem.allCases.firstIndex(of: tab) ?? 0) { rect in
                            tabPositions[TabItem.allCases.firstIndex(of: tab) ?? 0] = rect
                        }
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.xlarge)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.xlarge)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(Theme.saudiGold)
                    .frame(
                        width: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero].width,
                        height: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero].height
                    )
                    .offset(
                        x: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero).midX - geometry.size.width / 2,
                        y: 0
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            )
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, Theme.Spacing.xs)
        }
        .frame(height: 80)
    }
}

struct TabPositionReader: View {
    let index: Int
    let coordinateSpace: String = "TabBarSpace"
    let onChange: (CGRect) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    onChange(geometry.frame(in: .named(coordinateSpace)))
                }
                .onChange(of: geometry.frame(in: .named(coordinateSpace))) { _, newValue in
                    onChange(newValue)
                }
        }
    }
}

enum TabItem: CaseIterable {
    case home, create, chat, profile
    
    var icon: String {
        switch self {
        case .home: return "square.grid.2x2"
        case .create: return "wand.and.stars"
        case .chat: return "bubble.left.and.text.bubble.right"
        case .profile: return "person.crop.circle"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .create: return "Create"
        case .chat: return "Chat"
        case .profile: return "Profile"
        }
    }
}
