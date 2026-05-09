//
//  AIGenerationView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct AIGenerationView: View {
    @StateObject private var projectManager = ProjectManager()
    @State private var isGenerating = false
    @State private var generationProgress: Double = 0.0
    @State private var currentStep: GenerationStep = .analyzing
    @State private var generatedResult: AIResult?
    @State private var showingResult = false
    @State private var showingSaveAlert = false
    
    // Form Data
    @State private var projectName = ""
    @State private var clientName = ""
    @State private var location = ""
    @State private var plotSize = ""
    @State private var totalArea = ""
    @State private var floors = 2
    @State private var selectedStyle: ArchitectureStyle = .modernSaudi
    
    enum GenerationStep: String, CaseIterable {
        case analyzing = "Analyzing Requirements"
        case designing = "Creating Design Concept"
        case generating = "Generating Architecture"
        case detailing = "Adding Details"
        case finalizing = "Finalizing Project"
        
        var description: String {
            switch self {
            case .analyzing:
                return "Understanding your project requirements and constraints"
            case .designing:
                return "Creating initial design concepts and layouts"
            case .generating:
                return "Generating detailed architectural plans"
            case .detailing:
                return "Adding materials, budget estimates, and specifications"
            case .finalizing:
                return "Finalizing project with AI optimization"
            }
        }
        
        var icon: String {
            switch self {
            case .analyzing: return "brain.head.profile"
            case .designing: return "pencil.and.ruler"
            case .generating: return "building.2.fill"
            case .detailing: return "cube.fill"
            case .finalizing: return "checkmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.xl) {
                    // Header
                    HeaderView()
                    
                    // Input Form
                    if !isGenerating {
                        InputFormView(
                            projectName: $projectName,
                            clientName: $clientName,
                            location: $location,
                            plotSize: $plotSize,
                            totalArea: $totalArea,
                            floors: $floors,
                            selectedStyle: $selectedStyle,
                            onGenerate: startGeneration
                        )
                    } else {
                        // Generation Progress
                        GenerationProgressView(
                            currentStep: currentStep,
                            progress: generationProgress,
                            projectName: projectName
                        )
                    }
                    
                    // Recent Projects
                    if !isGenerating {
                        RecentProjectsSection(
                            projects: projectManager.getRecentProjects(limit: 3),
                            onSeeAll: {
                                // Navigate to all projects
                            }
                        )
                    }
                }
                .padding(Theme.Spacing.lg)
            }
            .background(Theme.backgroundGradient)
            .navigationTitle("AI Architecture")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("History") {
                        // Navigate to project history
                    }
                    .foregroundStyle(Theme.saudiGold)
                }
            }
        }
        .sheet(isPresented: $showingResult) {
            if let result = generatedResult {
                NavigationView {
                    AIResultDetailView(result: result)
                }
            }
        }
        .alert("Project Saved!", isPresented: $showingSaveAlert) {
            Button("OK") { }
        } message: {
            Text("Your project has been saved successfully.")
        }
    }
    
    // MARK: - Generation Logic
    private func startGeneration() {
        guard !projectName.isEmpty && !location.isEmpty && !plotSize.isEmpty else {
            return
        }
        
        isGenerating = true
        generationProgress = 0.0
        currentStep = .analyzing
        
        // Simulate AI generation process
        simulateGeneration()
    }
    
    private func simulateGeneration() {
        let steps: [GenerationStep] = [.analyzing, .designing, .generating, .detailing, .finalizing]
        
        for (index, step) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 1.5) {
                currentStep = step
                generationProgress = Double(index + 1) / Double(steps.count)
                
                if step == .finalizing {
                    completeGeneration()
                }
            }
        }
    }
    
    private func completeGeneration() {
        // Generate sample result
        generatedResult = AIResult(
            projectName: projectName,
            clientName: clientName.isEmpty ? "Client" : clientName,
            location: location,
            plotSize: Double(plotSize) ?? 1000,
            totalArea: Double(totalArea) ?? 500,
            floors: floors,
            style: selectedStyle,
            summary: generateSummary(),
            rooms: generateRooms(),
            materials: generateMaterials(),
            budget: generateBudget(),
            images: generateImages()
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isGenerating = false
            showingResult = true
        }
    }
    
    // MARK: - Data Generation Methods
    private func generateSummary() -> ArchitectureSummary {
        ArchitectureSummary(
            concept: "AI-generated \(selectedStyle.rawValue.lowercased()) design tailored for your specific requirements in \(location).",
            keyFeatures: [
                "Optimized layout for \(selectedStyle.rawValue) aesthetics",
                "Climate-adapted design for \(location)",
                "Modern amenities with traditional elements",
                "Sustainable building practices",
                "Smart home integration"
            ],
            sustainabilityScore: Double.random(in: 0.75...0.95),
            energyEfficiency: "Grade A - Advanced energy-efficient systems",
            climateAdaptation: "Designed for local climate conditions",
            culturalElements: [
                "\(selectedStyle.rawValue) architectural elements",
                "Local material recommendations",
                "Cultural design considerations",
                "Regional building practices"
            ]
        )
    }
    
    private func generateRooms() -> [Room] {
        let baseRooms = [
            Room(name: "Master Bedroom", area: Double.random(in: 35...45), floor: 1, purpose: .bedroom, features: ["Walk-in closet", "En-suite bathroom"], ventilation: "Natural ventilation", lighting: "LED lighting"),
            Room(name: "Living Room", area: Double.random(in: 40...60), floor: 1, purpose: .living, features: ["Entertainment center", "Fireplace"], ventilation: "Cross ventilation", lighting: "Natural light + LED"),
            Room(name: "Kitchen", area: Double.random(in: 25...35), floor: 1, purpose: .kitchen, features: ["Modern appliances", "Island"], ventilation: "Exhaust system", lighting: "Task lighting"),
            Room(name: "Majlis", area: Double.random(in: 30...50), floor: 1, purpose: .majlis, features: ["Traditional seating", "Decorative elements"], ventilation: "Natural ventilation", lighting: "Warm LED")
        ]
        
        return baseRooms
    }
    
    private func generateMaterials() -> [MaterialSuggestion] {
        MaterialSuggestion.sampleMaterials
    }
    
    private func generateBudget() -> BudgetEstimate {
        let baseAmount = Double(totalArea) ?? 500 * 3000 // SAR 3000 per m²
        
        return BudgetEstimate(
            total: baseAmount,
            breakdown: [
                BudgetCategory(name: "Foundation & Structure", amount: baseAmount * 0.30, percentage: 30.0),
                BudgetCategory(name: "Exterior & Roofing", amount: baseAmount * 0.25, percentage: 25.0),
                BudgetCategory(name: "Interior Finishing", amount: baseAmount * 0.20, percentage: 20.0),
                BudgetCategory(name: "Kitchen & Bathrooms", amount: baseAmount * 0.15, percentage: 15.0),
                BudgetCategory(name: "Landscaping", amount: baseAmount * 0.05, percentage: 5.0),
                BudgetCategory(name: "Smart Home & Systems", amount: baseAmount * 0.05, percentage: 5.0)
            ],
            currency: "SAR",
            contingency: baseAmount * 0.10,
            timeline: "8-12 months"
        )
    }
    
    private func generateImages() -> [GeneratedImage] {
        GeneratedImage.sampleImages
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("AI Architecture")
                        .font(Theme.Typography.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Create stunning architectural designs with AI")
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.royalGold)
                    .luxuryEntrance(isAnimating: true)
            }
            
            // AI Capabilities
            HStack(spacing: Theme.Spacing.lg) {
                CapabilityItem(icon: "sparkles", title: "AI-Powered", description: "Advanced algorithms")
                CapabilityItem(icon: "crown.fill", title: "Luxury", description: "Premium designs")
                CapabilityItem(icon: "globe", title: "Saudi", description: "Local styles")
                CapabilityItem(icon: "bolt.fill", title: "Fast", description: "Quick generation")
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
    }
}

// MARK: - Capability Item
struct CapabilityItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Theme.saudiGold)
            
            Text(title)
                .font(Theme.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
            
            Text(description)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

// MARK: - Input Form View
struct InputFormView: View {
    @Binding var projectName: String
    @Binding var clientName: String
    @Binding var location: String
    @Binding var plotSize: String
    @Binding var totalArea: String
    @Binding var floors: Int
    @Binding var selectedStyle: ArchitectureStyle
    let onGenerate: () -> Void
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                // Project Information
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("Project Information")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    VStack(spacing: Theme.Spacing.md) {
                        ModernTextField("Project Name", text: $projectName, icon: "building.2.fill")
                        ModernTextField("Client Name", text: $clientName, icon: "person.fill")
                        ModernTextField("Location", text: $location, icon: "location.fill")
                    }
                }
                
                // Specifications
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("Specifications")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    VStack(spacing: Theme.Spacing.md) {
                        ModernTextField("Plot Size (m²)", text: $plotSize, icon: "square.fill", keyboardType: .numberPad)
                        ModernTextField("Total Area (m²)", text: $totalArea, icon: "rectangle.3.group.fill", keyboardType: .numberPad)
                        
                        // Floors Picker
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Number of Floors")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.textSecondary)
                            
                            HStack {
                                ForEach(1...4, id: \.self) { floor in
                                    Button(action: { floors = floor }) {
                                        Text("\(floor)")
                                            .font(Theme.Typography.callout)
                                            .fontWeight(.medium)
                                            .frame(width: 50, height: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                    .fill(floors == floor ? Theme.saudiGold : Theme.surface)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                            .stroke(Theme.border, lineWidth: 1)
                                                    )
                                            )
                                            .foregroundStyle(floors == floor ? Theme.background : Theme.textSecondary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                
                // Style Selection
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("Architecture Style")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(ArchitectureStyle.allCases, id: \.self) { style in
                                StyleSelectionCard(
                                    style: style,
                                    isSelected: selectedStyle == style,
                                    onSelect: { selectedStyle = style }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.sm)
                    }
                }
                
                // Generate Button
                ModernButton("Generate Architecture", style: .primary) {
                    onGenerate()
                }
                .disabled(projectName.isEmpty || location.isEmpty || plotSize.isEmpty)
            }
        }
    }
}

// MARK: - Style Selection Card
struct StyleSelectionCard: View {
    let style: ArchitectureStyle
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: Theme.Spacing.sm) {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(style.accentColor.opacity(0.2))
                    .frame(width: 80, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(isSelected ? style.accentColor : Theme.border, lineWidth: isSelected ? 2 : 1)
                    )
                    .overlay(
                        Image(systemName: "crown.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(style.accentColor)
                    )
                
                Text(style.rawValue)
                    .font(Theme.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? style.accentColor : Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Generation Progress View
struct GenerationProgressView: View {
    let currentStep: AIGenerationView.GenerationStep
    let progress: Double
    let projectName: String
    
    var body: some View {
        PremiumCard {
            VStack(spacing: Theme.Spacing.lg) {
                // Loading Animation
                LuxuryLoadingView(
                    message: "Creating \(projectName)",
                    progress: progress,
                    showProgress: true
                )
                
                // Current Step
                VStack(spacing: Theme.Spacing.md) {
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: currentStep.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Theme.saudiGold)
                        
                        Text(currentStep.rawValue)
                            .font(Theme.Typography.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Theme.textPrimary)
                    }
                    
                    Text(currentStep.description)
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                
                // Progress Steps
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(Array(AIGenerationView.GenerationStep.allCases.enumerated()), id: \.offset) { index, step in
                        ProgressStepRow(
                            step: step,
                            isActive: step == currentStep,
                            isCompleted: AIGenerationView.GenerationStep.allCases.firstIndex(of: currentStep)! > index
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Progress Step Row
struct ProgressStepRow: View {
    let step: AIGenerationView.GenerationStep
    let isActive: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : isActive ? "circle.fill" : "circle")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isCompleted ? Theme.accentEmerald : isActive ? Theme.saudiGold : Theme.textTertiary)
            
            Text(step.rawValue)
                .font(Theme.Typography.callout)
                .fontWeight(isActive ? .semibold : .regular)
                .foregroundStyle(isCompleted ? Theme.accentEmerald : isActive ? Theme.textPrimary : Theme.textTertiary)
            
            Spacer()
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

// MARK: - Preview
#Preview("AI Generation View") {
    AIGenerationView()
}
