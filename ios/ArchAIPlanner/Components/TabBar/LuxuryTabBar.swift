//
//  LuxuryTabBar.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var tabPositions: [CGRect] = []
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                        HapticFeedbackManager.shared.selection()
                    }) {
                        VStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(selectedTab == tab ? Theme.background : Theme.textTertiary)
                            
                            Text(tab.title)
                                .font(Theme.Typography.refinedCaption)
                                .fontWeight(.medium)
                                .foregroundStyle(selectedTab == tab ? Theme.background : Theme.textTertiary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .padding(.horizontal, Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(selectedTab == tab ? Theme.royalGoldGradient : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(
                                            selectedTab == tab ? Theme.royalGold : Theme.border,
                                            lineWidth: selectedTab == tab ? 0 : 1
                                        )
                                )
                        )
                        .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                        .shadow(
                            color: selectedTab == tab ? Theme.Shadow.royalGold : Theme.Shadow.xs,
                            radius: selectedTab == tab ? 8 : 0
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
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Theme.royalGold.opacity(0.4),
                                        Theme.saudiGold.opacity(0.3),
                                        Theme.royalGold.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: Theme.Shadow.premium,
                        radius: 20,
                        x: 0,
                        y: 8
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(Theme.royalGoldGradient)
                    .frame(
                        width: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero].width,
                        height: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero].height
                    )
                    .offset(
                        x: tabPositions[TabItem.allCases.firstIndex(of: selectedTab) ?? 0, default: .zero].midX - geometry.size.width / 2,
                        y: 0
                    )
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
            )
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.xs)
            .onAppear {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isAnimating = false
                }
            }
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

// MARK: - Preview Providers
#Preview("Luxury Tab Bar") {
    VStack(spacing: Theme.Spacing.xl) {
        LuxuryTabBar(selectedTab: .constant(.home))
        
        Text("Premium Tab Bar with Luxury Aesthetic")
            .font(Theme.Typography.headline)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.textPrimary)
            .multilineTextAlignment(.center)
    }
    .padding()
    .background(Theme.backgroundGradient)
}

#Preview("Selected State") {
    LuxuryTabBar(selectedTab: .constant(.create))
        .previewDisplayName("Selected Create Tab")
}

#Preview("Different Tabs") {
    VStack(spacing: Theme.Spacing.lg) {
        LuxuryTabBar(selectedTab: .constant(.home))
        LuxuryTabBar(selectedTab: .constant(.chat))
    }
    .padding()
    .background(Theme.background)
    .previewDisplayName("Multiple Tab Bars")
}

#Preview("iPhone 15 Pro") {
    LuxuryTabBar(selectedTab: .constant(.profile))
        .previewDevice(PreviewDevices.iPhone15Pro.name)
}

#Preview("iPad Pro") {
    LuxuryTabBar(selectedTab: .constant(.home))
        .previewDevice(PreviewDevices.iPadPro.name)
}
