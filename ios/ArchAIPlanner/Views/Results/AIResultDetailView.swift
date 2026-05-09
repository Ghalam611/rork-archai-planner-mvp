//
//  AIResultDetailView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct AIResultDetailView: View {
    let result: AIResult
    @State private var selectedTab: ResultTab = .overview
    @State private var showingSaveAlert = false
    @State private var isSaved = false
    
    enum ResultTab: String, CaseIterable {
        case overview = "Overview"
        case rooms = "Rooms"
        case materials = "Materials"
        case budget = "Budget"
        case images = "Images"
        
        var icon: String {
            switch self {
            case .overview: return "house.fill"
            case .rooms: return "rectangle.3.group.fill"
            case .materials: return "cube.fill"
            case .budget: return "dollarsign.circle.fill"
            case .images: return "photo.fill"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Header
                resultHeaderView
                
                // Tab Selection
                tabSelectionView
                
                // Content
                tabContentView
            }
        }
        .background(Theme.backgroundGradient)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSaveAlert = true }) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundStyle(isSaved ? Theme.accentCopper : Theme.textSecondary)
                }
            }
        }
        .alert("Save Project", isPresented: $showingSaveAlert) {
            Button("Save", role: .destructive) {
                saveProject()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Save this project to your collection?")
        }
    }
    
    // MARK: - Header View
    private var resultHeaderView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Project Title
            VStack(spacing: Theme.Spacing.sm) {
                Text(result.projectName)
                    .font(Theme.Typography.title1)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "location.fill")
                        .foregroundStyle(Theme.saudiGold)
                    Text(result.location)
                        .font(Theme.Typography.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            
            // Style Badge
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "crown.fill")
                    .foregroundStyle(result.style.accentColor)
                Text(result.style.rawValue)
                    .font(Theme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(result.style.accentColor)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(result.style.accentColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(result.style.accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Key Metrics
            HStack(spacing: Theme.Spacing.xl) {
                MetricCard(
                    title: "Total Area",
                    value: String(format: "%.0f m²", result.totalArea),
                    icon: "square.fill"
                )
                
                MetricCard(
                    title: "Floors",
                    value: "\(result.floors)",
                    icon: "building.2.fill"
                )
                
                MetricCard(
                    title: "Rooms",
                    value: "\(result.rooms.count)",
                    icon: "door.left.right.open.fill"
                )
            }
            
            // AI Confidence
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "brain.fill")
                    .foregroundStyle(Theme.accentEmerald)
                Text("AI Confidence: \(Int(result.aiConfidence * 100))%")
                    .font(Theme.Typography.caption1)
                    .foregroundStyle(Theme.textSecondary)
                Text("•")
                    .foregroundStyle(Theme.textTertiary)
                Text("Generated in \(Int(result.processingTime))s")
                    .font(Theme.Typography.caption1)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(Theme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.xxxlarge)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Theme.royalGold.opacity(0.3),
                                    Theme.saudiGold.opacity(0.2),
                                    Theme.royalGold.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(Theme.Spacing.lg)
    }
    
    // MARK: - Tab Selection
    private var tabSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(ResultTab.allCases, id: \.self) { tab in
                    Button(action: { selectedTab = tab }) {
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 14, weight: .medium))
                            Text(tab.rawValue)
                                .font(Theme.Typography.callout)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(selectedTab == tab ? Theme.saudiGold : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        )
                        .foregroundStyle(selectedTab == tab ? Theme.background : Theme.textSecondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .padding(.vertical, Theme.Spacing.md)
    }
    
    // MARK: - Tab Content
    @ViewBuilder
    private var tabContentView: some View {
        Group {
            switch selectedTab {
            case .overview:
                OverviewTabView(result: result)
            case .rooms:
                RoomsTabView(rooms: result.rooms)
            case .materials:
                MaterialsTabView(materials: result.materials)
            case .budget:
                BudgetTabView(budget: result.budget)
            case .images:
                ImagesTabView(images: result.images)
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.xl)
    }
    
    // MARK: - Actions
    private func saveProject() {
        // Implement project saving logic
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isSaved = true
        }
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Theme.saudiGold)
            
            Text(value)
                .font(Theme.Typography.title3)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
            
            Text(title)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview("AI Result Detail") {
    NavigationView {
        AIResultDetailView(result: .sample)
    }
    .background(Theme.background)
}

// MARK: - Sample Data Extension
extension AIResult {
    static let sample = AIResult(
        projectName: "Royal Desert Villa",
        clientName: "Al Saud Family",
        location: "Riyadh, Saudi Arabia",
        plotSize: 2000,
        totalArea: 850,
        floors: 2,
        style: .modernSaudi,
        summary: .sample,
        rooms: Room.sampleRooms,
        materials: MaterialSuggestion.sampleMaterials,
        budget: .sample,
        images: GeneratedImage.sampleImages
    )
}

extension ArchitectureSummary {
    static let sample = ArchitectureSummary(
        concept: "A modern interpretation of traditional Saudi architecture, combining contemporary luxury with cultural heritage elements.",
        keyFeatures: [
            "Grand Majlis with traditional geometric patterns",
            "Courtyard with water feature",
            "Rooftop terrace with desert views",
            "Smart home integration",
            "Sustainable cooling systems"
        ],
        sustainabilityScore: 0.85,
        energyEfficiency: "Grade A - Advanced solar panel system with battery storage",
        climateAdaptation: "Passive cooling design with wind towers and shaded courtyards",
        culturalElements: [
            "Najdi-style facade",
            "Islamic geometric patterns",
            "Traditional mashrabiya screens",
            "Desert garden landscaping"
        ]
    )
}
