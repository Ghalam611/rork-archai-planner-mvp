//
//  OverviewTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct OverviewTabView: View {
    let result: AIResult
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.lg) {
            // Concept Section
            ConceptSection(summary: result.summary)
            
            // Key Features
            KeyFeaturesSection(features: result.summary.keyFeatures)
            
            // Sustainability Score
            SustainabilitySection(summary: result.summary)
            
            // Climate Adaptation
            ClimateSection(summary: result.summary)
            
            // Cultural Elements
            CulturalElementsSection(elements: result.summary.culturalElements)
        }
    }
}

// MARK: - Concept Section
struct ConceptSection: View {
    let summary: ArchitectureSummary
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.saudiGold)
                    
                    Text("Design Concept")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                Text(summary.concept)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
        }
    }
}

// MARK: - Key Features Section
struct KeyFeaturesSection: View {
    let features: [String]
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentAmber)
                    
                    Text("Key Features")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Theme.Spacing.md) {
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        FeatureItem(feature: feature, index: index)
                    }
                }
            }
        }
    }
}

struct FeatureItem: View {
    let feature: String
    let index: Int
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Text("\(index + 1)")
                .font(Theme.Typography.caption1)
                .fontWeight(.bold)
                .foregroundStyle(Theme.background)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Theme.saudiGold)
                )
            
            Text(feature)
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(2)
        }
        .padding(Theme.Spacing.sm)
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

// MARK: - Sustainability Section
struct SustainabilitySection: View {
    let summary: ArchitectureSummary
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentEmerald)
                    
                    Text("Sustainability")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Score Display
                VStack(spacing: Theme.Spacing.sm) {
                    HStack {
                        Text("Sustainability Score")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.textSecondary)
                        
                        Spacer()
                        
                        Text(summary.sustainabilityRating)
                            .font(Theme.Typography.callout)
                            .fontWeight(.bold)
                            .foregroundStyle(summary.sustainabilityScore > 0.7 ? Theme.accentEmerald : Theme.accentCopper)
                    }
                    
                    // Progress Bar
                    ProgressView(value: summary.sustainabilityScore)
                        .progressViewStyle(
                            LinearProgressViewStyle(
                                tint: summary.sustainabilityScore > 0.7 ? Theme.accentEmerald : Theme.accentCopper,
                                trackColor: Theme.surfaceLight
                            )
                        )
                        .scaleEffect(y: 2.0)
                }
                
                // Energy Efficiency
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Energy Efficiency")
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text(summary.energyEfficiency)
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(1)
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

// MARK: - Climate Section
struct ClimateSection: View {
    let summary: ArchitectureSummary
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentAmber)
                    
                    Text("Climate Adaptation")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                Text(summary.climateAdaptation)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
        }
    }
}

// MARK: - Cultural Elements Section
struct CulturalElementsSection: View {
    let elements: [String]
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.royalGold)
                    
                    Text("Cultural Elements")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Theme.Spacing.sm) {
                    ForEach(elements, id: \.self) { element in
                        HStack(spacing: Theme.Spacing.sm) {
                            Image(systemName: "diamond.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.saudiGold)
                            
                            Text(element)
                                .font(Theme.Typography.caption1)
                                .foregroundStyle(Theme.textSecondary)
                                .lineLimit(2)
                        }
                        .padding(Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                .fill(Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                        .stroke(Theme.saudiGold.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("Overview Tab") {
    ScrollView {
        OverviewTabView(result: .sample)
    }
    .background(Theme.background)
}
