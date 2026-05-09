//
//  BudgetTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct BudgetTabView: View {
    let budget: BudgetEstimate
    @State private var selectedViewType: BudgetViewType = .breakdown
    
    enum BudgetViewType: String, CaseIterable {
        case breakdown = "Breakdown"
        case chart = "Chart"
        case timeline = "Timeline"
        
        var icon: String {
            switch self {
            case .breakdown: return "list.bullet.rectangle"
            case .chart: return "chart.pie.fill"
            case .timeline: return "calendar"
            }
        }
    }
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.lg) {
            // View Type Selection
            BudgetViewTypeSelection(
                selectedType: $selectedViewType
            )
            
            // Budget Overview
            BudgetOverviewCard(budget: budget)
            
            // Content based on selected view
            Group {
                switch selectedViewType {
                case .breakdown:
                    BudgetBreakdownView(budget: budget)
                case .chart:
                    BudgetChartView(budget: budget)
                case .timeline:
                    BudgetTimelineView(budget: budget)
                }
            }
        }
    }
}

// MARK: - Budget View Type Selection
struct BudgetViewTypeSelection: View {
    @Binding var selectedType: BudgetTabView.BudgetViewType
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            ForEach(BudgetTabView.BudgetViewType.allCases, id: \.self) { type in
                Button(action: { selectedType = type }) {
                    HStack(spacing: Theme.Spacing.xs) {
                        Image(systemName: type.icon)
                            .font(.system(size: 14, weight: .medium))
                        Text(type.rawValue)
                            .font(Theme.Typography.callout)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(selectedType == type ? Theme.saudiGold : Theme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                    )
                    .foregroundStyle(selectedType == type ? Theme.background : Theme.textSecondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}

// MARK: - Budget Overview Card
struct BudgetOverviewCard: View {
    let budget: BudgetEstimate
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.royalGold)
                    
                    Text("Budget Overview")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Main Budget Display
                VStack(spacing: Theme.Spacing.lg) {
                    HStack {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Base Cost")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.textSecondary)
                            
                            Text(budget.formattedTotal)
                                .font(Theme.Typography.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: Theme.Spacing.xs) {
                            Text("With Contingency")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.textSecondary)
                            
                            Text(budget.formattedTotalWithContingency)
                                .font(Theme.Typography.title1)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.saudiGold)
                        }
                    }
                    
                    // Contingency Info
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.accentAmber)
                        
                        Text(String(format: "Includes %.0f%% contingency buffer (%.0f SAR)", 
                                  (budget.contingency / budget.total) * 100, 
                                  budget.contingency))
                            .font(Theme.Typography.caption1)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(Theme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .fill(Theme.accentAmber.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                    .stroke(Theme.accentAmber.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    // Timeline
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.accentSapphire)
                        
                        Text("Estimated Timeline: \(budget.timeline)")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Budget Breakdown View
struct BudgetBreakdownView: View {
    let budget: BudgetEstimate
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentCopper)
                    
                    Text("Cost Breakdown")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVStack(spacing: Theme.Spacing.sm) {
                    ForEach(budget.breakdown) { category in
                        BudgetCategoryRow(category: category)
                    }
                }
            }
        }
    }
}

// MARK: - Budget Category Row
struct BudgetCategoryRow: View {
    let category: BudgetCategory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(category.name)
                    .font(Theme.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                
                Text(String(format: "%.1f%% of total", category.percentage))
                    .font(Theme.Typography.caption1)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: Theme.Spacing.xs) {
                Text("\(category.currency) \(category.formattedAmount)")
                    .font(Theme.Typography.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.saudiGold)
                
                // Progress Bar
                ProgressView(value: category.percentage / 100.0)
                    .progressViewStyle(
                        LinearProgressViewStyle(
                            tint: category.percentage > 20 ? Theme.saudiGold : Theme.accentAmber,
                            trackColor: Theme.surfaceLight
                        )
                    )
                    .frame(width: 80)
                    .scaleEffect(y: 1.5)
            }
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

// MARK: - Budget Chart View
struct BudgetChartView: View {
    let budget: BudgetEstimate
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentSapphire)
                    
                    Text("Budget Distribution")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Pie Chart Placeholder
                VStack(spacing: Theme.Spacing.lg) {
                    ZStack {
                        Circle()
                            .fill(Theme.surface)
                            .frame(width: 200, height: 200)
                            .overlay(
                                Circle()
                                    .stroke(Theme.border, lineWidth: 2)
                            )
                        
                        VStack(spacing: Theme.Spacing.xs) {
                            Text(budget.formattedTotalWithContingency)
                                .font(Theme.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Total Budget")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                    
                    // Legend
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Theme.Spacing.sm) {
                        ForEach(Array(budget.breakdown.prefix(6).enumerated()), id: \.offset) { index, category in
                            HStack(spacing: Theme.Spacing.xs) {
                                Circle()
                                    .fill(colorForCategory(index))
                                    .frame(width: 12, height: 12)
                                
                                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                    Text(category.name)
                                        .font(Theme.Typography.caption2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Theme.textPrimary)
                                        .lineLimit(1)
                                    
                                    Text(String(format: "%.0f%%", category.percentage))
                                        .font(Theme.Typography.caption3)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func colorForCategory(_ index: Int) -> Color {
        let colors: [Color] = [
            Theme.saudiGold,
            Theme.accentCopper,
            Theme.accentEmerald,
            Theme.accentSapphire,
            Theme.accentAmber,
            Theme.richMaroon
        ]
        return colors[index % colors.count]
    }
}

// MARK: - Budget Timeline View
struct BudgetTimelineView: View {
    let budget: BudgetEstimate
    
    private var phases: [BudgetPhase] {
        [
            BudgetPhase(
                name: "Foundation & Structure",
                duration: "2-3 months",
                costPercentage: 0.35,
                description: "Excavation, foundation, and structural work"
            ),
            BudgetPhase(
                name: "Exterior & Roofing",
                duration: "1-2 months",
                costPercentage: 0.25,
                description: "Walls, roofing, windows, and exterior finishing"
            ),
            BudgetPhase(
                name: "Interior Finishing",
                duration: "2-3 months",
                costPercentage: 0.30,
                description: "Flooring, walls, kitchens, and bathrooms"
            ),
            BudgetPhase(
                name: "Landscaping & Final",
                duration: "1 month",
                costPercentage: 0.10,
                description: "Garden, irrigation, and final touches"
            )
        ]
    }
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentAmber)
                    
                    Text("Project Timeline")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVStack(spacing: Theme.Spacing.md) {
                    ForEach(Array(phases.enumerated()), id: \.offset) { index, phase in
                        BudgetPhaseRow(phase: phase, index: index)
                    }
                }
            }
        }
    }
}

// MARK: - Budget Phase
struct BudgetPhase {
    let name: String
    let duration: String
    let costPercentage: Double
    let description: String
}

// MARK: - Budget Phase Row
struct BudgetPhaseRow: View {
    let phase: BudgetPhase
    let index: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.md) {
            // Timeline Indicator
            VStack(spacing: Theme.Spacing.xs) {
                Circle()
                    .fill(Theme.saudiGold)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Theme.background, lineWidth: 2)
                    )
                
                if index < 3 {
                    Rectangle()
                        .fill(Theme.border)
                        .frame(width: 2, height: 40)
                }
            }
            
            // Phase Content
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Text(phase.name)
                        .font(Theme.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: Theme.Spacing.xs) {
                        Text(phase.duration)
                            .font(Theme.Typography.caption1)
                            .fontWeight(.medium)
                            .foregroundStyle(Theme.saudiGold)
                        
                        Text(String(format: "%.0f%% of budget", phase.costPercentage * 100))
                            .font(Theme.Typography.caption2)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                
                Text(phase.description)
                    .font(Theme.Typography.caption1)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(1)
                
                // Progress Bar
                ProgressView(value: phase.costPercentage)
                    .progressViewStyle(
                        LinearProgressViewStyle(
                            tint: Theme.saudiGold,
                            trackColor: Theme.surfaceLight
                        )
                    )
                    .scaleEffect(y: 1.5)
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

// MARK: - Preview
#Preview("Budget Tab") {
    ScrollView {
        BudgetTabView(budget: .sample)
    }
    .background(Theme.background)
}

// MARK: - Sample Data Extension
extension BudgetEstimate {
    static let sample = BudgetEstimate(
        total: 2500000,
        breakdown: [
            BudgetCategory(name: "Foundation & Structure", amount: 750000, percentage: 30.0),
            BudgetCategory(name: "Exterior & Roofing", amount: 625000, percentage: 25.0),
            BudgetCategory(name: "Interior Finishing", amount: 500000, percentage: 20.0),
            BudgetCategory(name: "Kitchen & Bathrooms", amount: 375000, percentage: 15.0),
            BudgetCategory(name: "Landscaping", amount: 125000, percentage: 5.0),
            BudgetCategory(name: "Smart Home & Systems", amount: 125000, percentage: 5.0)
        ],
        currency: "SAR",
        contingency: 250000,
        timeline: "8-12 months"
    )
}
