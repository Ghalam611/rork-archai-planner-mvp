//
//  AIResultCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct AIResultCard: View {
    let project: DesignProject
    @State private var isExpanded = false
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text(project.title)
                            .font(Theme.Typography.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("\(project.landSize) • \(project.floors) floors • \(project.bedrooms) bedrooms")
                            .font(Theme.Typography.caption1)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.saudiGold)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                
                // Style Badge
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.saudiGold)
                    
                    Text(project.style)
                        .font(Theme.Typography.caption1)
                        .fontWeight(.medium)
                        .foregroundStyle(Theme.saudiGold)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                .fill(Theme.saudiGold.opacity(0.1))
                        )
                }
            }
            .padding(Theme.Spacing.lg)
            .background(
                LinearGradient(
                    colors: [
                        Theme.saudiGold.opacity(0.1),
                        Theme.saudiGold.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Expandable Content
            if isExpanded {
                VStack(spacing: Theme.Spacing.lg) {
                    Divider()
                        .overlay(Theme.border)
                    
                    // Result Sections
                    VStack(spacing: Theme.Spacing.md) {
                        ResultSection(
                            title: "Space Distribution",
                            content: project.result.spaceDistribution,
                            icon: "rectangle.3.group"
                        )
                        
                        ResultSection(
                            title: "Room Layout",
                            content: project.result.roomLayout,
                            icon: "grid"
                        )
                        
                        ResultSection(
                            title: "Entrance Design",
                            content: project.result.entranceIdeas,
                            icon: "door.garage.closed"
                        )
                        
                        ResultSection(
                            title: "Style Description",
                            content: project.result.styleDescription,
                            icon: "paintbrush.fill"
                        )
                        
                        ResultSection(
                            title: "Improvements",
                            content: project.result.improvements,
                            icon: "sparkles"
                        )
                    }
                }
                .padding(Theme.Spacing.lg)
                .background(Theme.surface)
                .opacity(animateContent ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.1), value: animateContent)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxlarge)
                .stroke(Theme.saudiGold.opacity(0.3), lineWidth: 1)
        )
        .shadow(
            color: Theme.Shadow.gold,
            radius: 20,
            x: 0,
            y: 10
        )
        .onAppear {
            animateContent = true
        }
        .onChange(of: isExpanded) { _, newValue in
            if newValue {
                animateContent = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateContent = true
                }
            }
        }
    }
}

struct ResultSection: View {
    let title: String
    let content: String
    let icon: String
    @State private var isVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.saudiGold)
                
                Text(title.uppercased())
                    .font(Theme.Typography.caption1)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.saudiGold)
                    .tracking(1.2)
            }
            
            Text(content)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.1), value: isVisible)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            isVisible = true
        }
    }
}

struct AIResultCard_Previews: PreviewProvider {
    static var previews: some View {
        AIResultCard(project: DesignProject.samples.first!)
            .padding()
            .background(Theme.background)
    }
}
