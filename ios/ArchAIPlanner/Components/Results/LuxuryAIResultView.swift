//
//  LuxuryAIResultView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryAIResultView: View {
    let project: DesignProject
    @State private var isExpanded = false
    @State private var animateContent = false
    @State private var selectedSection: ResultSectionType = .spaceDistribution
    @State private var showDetails = false
    
    enum ResultSectionType: String, CaseIterable {
        case spaceDistribution = "Space Distribution"
        case roomLayout = "Room Layout"
        case entranceIdeas = "Entrance Design"
        case styleDescription = "Style Description"
        case improvements = "Improvements"
        
        var icon: String {
            switch self {
            case .spaceDistribution: return "rectangle.3.group"
            case .roomLayout: return "grid"
            case .entranceIdeas: return "door.garage.closed"
            case .styleDescription: return "paintbrush.fill"
            case .improvements: return "sparkles"
            }
        }
        
        var color: Color {
            switch self {
            case .spaceDistribution: return Theme.accentEmerald
            case .roomLayout: return Theme.accentSapphire
            case .entranceIdeas: return Theme.accentAmber
            case .styleDescription: return Theme.royalGold
            case .improvements: return Theme.accentCopper
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Premium Header
            PremiumCard(
                shadowColor: Theme.Shadow.royalGold,
                borderColor: Theme.royalGold.opacity(0.4),
                borderWidth: 1.5
            ) {
                VStack(spacing: Theme.Spacing.lg) {
                    // Title Section
                    HStack {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text(project.title)
                                .font(Theme.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: Theme.Spacing.sm) {
                                Image(systemName: "ruler.fill")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Theme.royalGold)
                                
                                Text("\(project.landSize) • \(project.floors) floors • \(project.bedrooms) bedrooms")
                                    .font(Theme.Typography.caption1)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Expand/Collapse Button
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                                animateContent = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    animateContent = true
                                }
                            }
                            HapticFeedbackManager.shared.selection()
                        }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Theme.royalGold)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        }
                    }
                    
                    // Style Badge
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.royalGold)
                        
                        Text(project.style)
                            .font(Theme.Typography.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(Theme.royalGold)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .fill(Theme.royalGold.opacity(0.15))
                            )
                    }
                }
            }
            .luxuryEntrance(isAnimating: animateContent, delay: 0.2)
            
            // Expandable Content
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .overlay(Theme.royalGold.opacity(0.3))
                    
                    // Section Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(ResultSectionType.allCases, id: \.self) { section in
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedSection = section
                                    }
                                    HapticFeedbackManager.shared.light()
                                }) {
                                    VStack(spacing: Theme.Spacing.xs) {
                                        Image(systemName: section.icon)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(selectedSection == section ? Theme.background : section.color)
                                        
                                        Text(section.rawValue)
                                            .font(Theme.Typography.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(selectedSection == section ? Theme.background : section.color)
                                    }
                                    .padding(.horizontal, Theme.Spacing.md)
                                    .padding(.vertical, Theme.Spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .fill(selectedSection == section ? section.color : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                    .stroke(section.color, lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                    .scrollIndicators(.hidden)
                    
                    // Section Content
                    GlassCard {
                        sectionContent(for: selectedSection)
                            .luxuryEntrance(isAnimating: animateContent, delay: 0.4)
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                }
                .background(Theme.surface)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .stroke(
                    LinearGradient(
                        colors: [
                            Theme.royalGold.opacity(0.4),
                            Theme.saudiGold.opacity(0.2),
                            Theme.royalGold.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(
            color: Theme.Shadow.royalGold,
            radius: 30,
            x: 0,
            y: 15
        )
        .onAppear {
            animateContent = true
        }
        .onChange(of: isExpanded) { _, newValue in
            if newValue {
                animateContent = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animateContent = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func sectionContent(for section: ResultSectionType) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            switch section {
            case .spaceDistribution:
                resultSection(
                    title: "Space Distribution",
                    content: project.result.spaceDistribution,
                    icon: section.icon,
                    color: section.color
                )
            case .roomLayout:
                resultSection(
                    title: "Room Layout",
                    content: project.result.roomLayout,
                    icon: section.icon,
                    color: section.color
                )
            case .entranceIdeas:
                resultSection(
                    title: "Entrance Design",
                    content: project.result.entranceIdeas,
                    icon: section.icon,
                    color: section.color
                )
            case .styleDescription:
                resultSection(
                    title: "Style Description",
                    content: project.result.styleDescription,
                    icon: section.icon,
                    color: section.color
                )
            case .improvements:
                resultSection(
                    title: "Improvements",
                    content: project.result.improvements,
                    icon: section.icon,
                    color: section.color
                )
            }
        }
    }
    
    @ViewBuilder
    private func resultSection(title: String, content: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                
                Text(title.uppercased())
                    .font(Theme.Typography.caption1)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                    .tracking(1.2)
                
                Spacer()
                
                Button(action: {
                    showDetails.toggle()
                    HapticFeedbackManager.shared.light()
                }) {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(color)
                        .rotationEffect(.degrees(showDetails ? 180 : 0))
                }
            }
            
            Text(content)
                .font(Theme.Typography.luxuryBody)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)
                .multilineTextAlignment(.leading)
                .opacity(showDetails ? 1.0 : 0.8)
                .animation(.easeInOut(duration: 0.3), value: showDetails)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview Providers
#Preview("Luxury AI Result") {
    LuxuryAIResultView(project: MockData.projects.first!)
        .padding()
        .background(Theme.background)
}

#Preview("Expanded State") {
    LuxuryAIResultView(project: MockData.projects.first!)
        .padding()
        .background(Theme.background)
        .previewDisplayName("Expanded State")
        .onAppear {
            // Simulate expanded state
        }
}

#Preview("Different Projects") {
    VStack(spacing: Theme.Spacing.lg) {
        ForEach(MockData.projects.prefix(2)) { project in
            LuxuryAIResultView(project: project)
        }
    }
    .padding()
    .background(Theme.background)
    .previewDisplayName("Multiple Projects")
}

#Preview("iPhone 15 Pro") {
    LuxuryAIResultView(project: MockData.projects.first!)
        .padding()
        .background(Theme.background)
        .previewDevice(PreviewDevices.iPhone15Pro.name)
}

#Preview("iPad Pro") {
    LuxuryAIResultView(project: MockData.projects.first!)
        .padding()
        .background(Theme.background)
        .previewDevice(PreviewDevices.iPadPro.name)
}
