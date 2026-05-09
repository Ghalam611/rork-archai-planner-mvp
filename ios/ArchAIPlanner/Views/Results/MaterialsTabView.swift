//
//  MaterialsTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct MaterialsTabView: View {
    let materials: [MaterialSuggestion]
    @State private var selectedCategory: MaterialSuggestion.MaterialCategory = .foundation
    
    private var categories: [MaterialSuggestion.MaterialCategory] {
        MaterialSuggestion.MaterialCategory.allCases
    }
    
    private var filteredMaterials: [MaterialSuggestion] {
        materials.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.lg) {
            // Category Selection
            CategorySelectionView(
                categories: categories,
                selectedCategory: $selectedCategory
            )
            
            // Materials List
            MaterialsListView(materials: filteredMaterials)
            
            // Materials Summary
            MaterialsSummaryView(materials: materials)
        }
    }
}

// MARK: - Category Selection View
struct CategorySelectionView: View {
    let categories: [MaterialSuggestion.MaterialCategory]
    @Binding var selectedCategory: MaterialSuggestion.MaterialCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(categories, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: category.icon)
                                .font(.system(size: 14, weight: .medium))
                            Text(category.rawValue)
                                .font(Theme.Typography.caption1)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(selectedCategory == category ? Theme.saudiGold : Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        )
                        .foregroundStyle(selectedCategory == category ? Theme.background : Theme.textSecondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
    }
}

// MARK: - Materials List View
struct MaterialsListView: View {
    let materials: [MaterialSuggestion]
    
    var body: some View {
        if materials.isEmpty {
            EmptyMaterialsView()
        } else {
            LazyVStack(spacing: Theme.Spacing.md) {
                ForEach(materials) { material in
                    MaterialCard(material: material)
                }
            }
        }
    }
}

// MARK: - Empty Materials View
struct EmptyMaterialsView: View {
    var body: some View {
        PremiumCard {
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.textTertiary)
                
                Text("No Materials Available")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Materials for this category will be suggested by our AI based on your project requirements.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(Theme.Spacing.xl)
        }
    }
}

// MARK: - Material Card
struct MaterialCard: View {
    let material: MaterialSuggestion
    @State private var isExpanded = false
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text(material.name)
                            .font(Theme.Typography.callout)
                            .fontWeight(.bold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        HStack(spacing: Theme.Spacing.sm) {
                            Image(systemName: material.category.icon)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Theme.saudiGold)
                            
                            Text(material.category.rawValue)
                                .font(Theme.Typography.caption2)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: Theme.Spacing.xs) {
                        Text(String(format: "SAR %.0f/m²", material.estimatedCost))
                            .font(Theme.Typography.callout)
                            .fontWeight(.bold)
                            .foregroundStyle(Theme.saudiGold)
                        
                        HStack(spacing: Theme.Spacing.xs) {
                            if material.localAvailability {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.accentEmerald)
                                Text("Local")
                                    .font(Theme.Typography.caption2)
                                    .foregroundStyle(Theme.accentEmerald)
                            } else {
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.accentAmber)
                                Text("Import")
                                    .font(Theme.Typography.caption2)
                                    .foregroundStyle(Theme.accentAmber)
                            }
                        }
                    }
                }
                
                // Description
                Text(material.description)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(1)
                    .lineLimit(isExpanded ? nil : 2)
                
                // Expand/Collapse Button
                if material.description.count > 100 {
                    Button(action: { isExpanded.toggle() }) {
                        HStack {
                            Text(isExpanded ? "Show Less" : "Show More")
                                .font(Theme.Typography.caption1)
                                .fontWeight(.medium)
                                .foregroundStyle(Theme.saudiGold)
                            
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(Theme.saudiGold)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Properties
                HStack(spacing: Theme.Spacing.lg) {
                    PropertyChip(
                        title: "Durability",
                        value: material.durability,
                        color: Theme.accentEmerald
                    )
                    
                    PropertyChip(
                        title: "Sustainability",
                        value: material.sustainability,
                        color: Theme.accentSapphire
                    )
                }
                
                // Benefits (Expanded)
                if isExpanded && !material.benefits.isEmpty {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Key Benefits")
                            .font(Theme.Typography.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Theme.Spacing.sm) {
                            ForEach(material.benefits, id: \.self) { benefit in
                                HStack(spacing: Theme.Spacing.xs) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Theme.accentEmerald)
                                    
                                    Text(benefit)
                                        .font(Theme.Typography.caption2)
                                        .foregroundStyle(Theme.textSecondary)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                    .padding(Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .fill(Theme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
}

// MARK: - Property Chip
struct PropertyChip: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
            
            Text(value)
                .font(Theme.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .padding(.horizontal, Theme.Spacing.sm)
        .padding(.vertical, Theme.Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Materials Summary View
struct MaterialsSummaryView: View {
    let materials: [MaterialSuggestion]
    
    private var totalEstimatedCost: Double {
        materials.reduce(0) { $0 + $1.estimatedCost }
    }
    
    private var localMaterialsCount: Int {
        materials.filter { $0.localAvailability }.count
    }
    
    private var sustainabilityScore: Double {
        let scores = ["Excellent": 1.0, "Good": 0.8, "Moderate": 0.6, "Poor": 0.4]
        let averageScore = materials.compactMap { scores[$0.sustainability] }.reduce(0, +) / Double(materials.count)
        return materials.isEmpty ? 0 : averageScore
    }
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.royalGold)
                    
                    Text("Materials Summary")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Theme.Spacing.md) {
                    SummaryCard(
                        title: "Total Materials",
                        value: "\(materials.count)",
                        icon: "cube.fill",
                        color: Theme.saudiGold
                    )
                    
                    SummaryCard(
                        title: "Local Sourced",
                        value: "\(localMaterialsCount)",
                        icon: "location.fill",
                        color: Theme.accentEmerald
                    )
                    
                    SummaryCard(
                        title: "Avg Cost/m²",
                        value: String(format: "%.0f", totalEstimatedCost / Double(max(materials.count, 1))),
                        icon: "dollarsign.circle.fill",
                        color: Theme.accentAmber
                    )
                }
                
                // Sustainability Rating
                VStack(spacing: Theme.Spacing.sm) {
                    HStack {
                        Text("Overall Sustainability")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.textSecondary)
                        
                        Spacer()
                        
                        Text(sustainabilityScore > 0.7 ? "Excellent" : sustainabilityScore > 0.5 ? "Good" : "Moderate")
                            .font(Theme.Typography.callout)
                            .fontWeight(.bold)
                            .foregroundStyle(sustainabilityScore > 0.7 ? Theme.accentEmerald : Theme.accentAmber)
                    }
                    
                    ProgressView(value: sustainabilityScore)
                        .progressViewStyle(
                            LinearProgressViewStyle(
                                tint: sustainabilityScore > 0.7 ? Theme.accentEmerald : Theme.accentAmber,
                                trackColor: Theme.surfaceLight
                            )
                        )
                        .scaleEffect(y: 2.0)
                }
                .padding(Theme.Spacing.md)
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
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(Theme.Typography.callout)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
            
            Text(title)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview("Materials Tab") {
    ScrollView {
        MaterialsTabView(materials: MaterialSuggestion.sampleMaterials)
    }
    .background(Theme.background)
}

// MARK: - Sample Data Extension
extension MaterialSuggestion {
    static let sampleMaterials: [MaterialSuggestion] = [
        MaterialSuggestion(
            name: "Reinforced Concrete Foundation",
            category: .foundation,
            description: "High-strength reinforced concrete foundation designed for Saudi soil conditions with advanced moisture barrier technology.",
            benefits: ["Superior load capacity", "Termite resistant", "50+ year lifespan", "Low maintenance"],
            estimatedCost: 450,
            durability: "Excellent",
            sustainability: "Good",
            localAvailability: true
        ),
        MaterialSuggestion(
            name: "Saudi Limestone Cladding",
            category: .exterior,
            description: "Premium Saudi limestone with natural cooling properties, sourced locally from Riyadh quarries with traditional finishing techniques.",
            benefits: ["Natural insulation", "Authentic appearance", "Weather resistant", "Locally sourced"],
            estimatedCost: 280,
            durability: "Excellent",
            sustainability: "Excellent",
            localAvailability: true
        ),
        MaterialSuggestion(
            name: "Smart Glass Windows",
            category: .windows,
            description: "Electrochromic smart glass that adjusts tint based on sunlight intensity, reducing cooling costs by up to 40%.",
            benefits: ["Energy efficient", "UV protection", "Privacy control", "Modern appearance"],
            estimatedCost: 850,
            durability: "Good",
            sustainability: "Excellent",
            localAvailability: false
        ),
        MaterialSuggestion(
            name: "Traditional Mashrabiya Screens",
            category: .finishing,
            description: "Handcrafted wooden mashrabiya screens with geometric patterns, providing privacy while allowing natural ventilation.",
            benefits: ["Cultural authenticity", "Natural ventilation", "Artistic value", "Privacy"],
            estimatedCost: 320,
            durability: "Good",
            sustainability: "Excellent",
            localAvailability: true
        ),
        MaterialSuggestion(
            name: "Italian Marble Flooring",
            category: .flooring,
            description: "Premium Carrara marble with polished finish, ideal for luxury spaces with high-end aesthetic requirements.",
            benefits: ["Luxury appearance", "High durability", "Easy maintenance", "Heat resistant"],
            estimatedCost: 650,
            durability: "Excellent",
            sustainability: "Moderate",
            localAvailability: false
        ),
        MaterialSuggestion(
            name: "Solar Roof Tiles",
            category: .roofing,
            description: "Integrated solar roof tiles that generate electricity while maintaining traditional Saudi architectural appearance.",
            benefits: ["Energy generation", "Reduced bills", "Eco-friendly", "Government incentives"],
            estimatedCost: 520,
            durability: "Good",
            sustainability: "Excellent",
            localAvailability: true
        )
    ]
}
