//
//  ProjectManager.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI
import Foundation

class ProjectManager: ObservableObject {
    @Published var savedProjects: [AIResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let projectsKey = "saved_architecture_projects"
    
    init() {
        loadProjects()
    }
    
    // MARK: - Save Project
    func saveProject(_ project: AIResult) {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Check if project already exists
            if !self.savedProjects.contains(where: { $0.id == project.id }) {
                self.savedProjects.insert(project, at: 0)
                self.saveToUserDefaults()
                
                // Show success feedback
                HapticFeedback.shared.light()
            } else {
                self.errorMessage = "Project already saved"
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Remove Project
    func removeProject(_ project: AIResult) {
        savedProjects.removeAll { $0.id == project.id }
        saveToUserDefaults()
        HapticFeedback.shared.medium()
    }
    
    // MARK: - Toggle Save Status
    func toggleSaveStatus(for project: AIResult) -> Bool {
        if savedProjects.contains(where: { $0.id == project.id }) {
            removeProject(project)
            return false
        } else {
            saveProject(project)
            return true
        }
    }
    
    // MARK: - Check if Project is Saved
    func isProjectSaved(_ project: AIResult) -> Bool {
        savedProjects.contains { $0.id == project.id }
    }
    
    // MARK: - Get Projects by Style
    func getProjectsByStyle(_ style: ArchitectureStyle) -> [AIResult] {
        savedProjects.filter { $0.style == style }
    }
    
    // MARK: - Get Recent Projects
    func getRecentProjects(limit: Int = 5) -> [AIResult] {
        Array(savedProjects.prefix(limit))
    }
    
    // MARK: - Search Projects
    func searchProjects(query: String) -> [AIResult] {
        guard !query.isEmpty else { return savedProjects }
        
        return savedProjects.filter { project in
            project.projectName.localizedCaseInsensitiveContains(query) ||
            project.clientName.localizedCaseInsensitiveContains(query) ||
            project.location.localizedCaseInsensitiveContains(query) ||
            project.style.rawValue.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Export Project
    func exportProject(_ project: AIResult) -> URL? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(project)
            
            // Create temporary file
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "\(project.projectName.replacingOccurrences(of: " ", with: "_"))_\(Date().timeIntervalSince1970).json"
            let fileURL = tempDir.appendingPathComponent(fileName)
            
            try data.write(to: fileURL)
            return fileURL
        } catch {
            errorMessage = "Failed to export project: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - Import Project
    func importProject(from url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let project = try decoder.decode(AIResult.self, from: data)
            saveProject(project)
            return true
        } catch {
            errorMessage = "Failed to import project: \(error.localizedDescription)"
            return false
        }
    }
    
    // MARK: - Clear All Projects
    func clearAllProjects() {
        savedProjects.removeAll()
        saveToUserDefaults()
        HapticFeedback.shared.heavy()
    }
    
    // MARK: - Private Methods
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(savedProjects)
            userDefaults.set(data, forKey: projectsKey)
        } catch {
            errorMessage = "Failed to save projects: \(error.localizedDescription)"
        }
    }
    
    private func loadProjects() {
        guard let data = userDefaults.data(forKey: projectsKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            savedProjects = try decoder.decode([AIResult].self, from: data)
        } catch {
            errorMessage = "Failed to load projects: \(error.localizedDescription)"
            savedProjects = []
        }
    }
}

// MARK: - Project Statistics
extension ProjectManager {
    var totalProjectsCount: Int {
        savedProjects.count
    }
    
    var totalBudgetValue: Double {
        savedProjects.reduce(0) { $0 + $1.budget.totalWithContingency }
    }
    
    var mostUsedStyle: ArchitectureStyle? {
        let styleCounts = Dictionary(grouping: savedProjects, by: { $0.style })
            .mapValues { $0.count }
        
        return styleCounts.max(by: { $0.value < $1.value })?.key
    }
    
    var averageProjectSize: Double {
        guard !savedProjects.isEmpty else { return 0 }
        return savedProjects.reduce(0) { $0 + $1.totalArea } / Double(savedProjects.count)
    }
    
    var projectsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        
        return savedProjects.filter { project in
            calendar.isDate(project.timestamp, equalTo: now, toGranularity: .month)
        }.count
    }
}

// MARK: - Sample Data Generator
extension ProjectManager {
    func generateSampleProjects() {
        let sampleProjects = [
            AIResult(
                projectName: "Royal Desert Villa",
                clientName: "Al Saud Family",
                location: "Riyadh, Saudi Arabia",
                plotSize: 2000,
                totalArea: 850,
                floors: 2,
                style: .modernSaudi,
                summary: ArchitectureSummary.sample,
                rooms: Room.sampleRooms,
                materials: MaterialSuggestion.sampleMaterials,
                budget: BudgetEstimate.sample,
                images: GeneratedImage.sampleImages
            ),
            AIResult(
                projectName: "Traditional Najdi Palace",
                clientName: "Royal Family",
                location: "Diriyah, Saudi Arabia",
                plotSize: 3500,
                totalArea: 1200,
                floors: 3,
                style: .traditionalNajdi,
                summary: ArchitectureSummary(
                    concept: "Authentic Najdi palace with traditional mud-brick construction and modern amenities.",
                    keyFeatures: [
                        "Traditional courtyard design",
                        "Ornate geometric patterns",
                        "Historical architectural elements",
                        "Modern luxury integration"
                    ],
                    sustainabilityScore: 0.75,
                    energyEfficiency: "Grade B - Traditional passive cooling with modern systems",
                    climateAdaptation: "Natural ventilation with wind towers and thick walls",
                    culturalElements: [
                        "Authentic Najdi construction",
                        "Traditional decorative elements",
                        "Historical preservation",
                        "Cultural heritage integration"
                    ]
                ),
                rooms: Room.sampleRooms + [
                    Room(
                        name: "Royal Majlis",
                        area: 85,
                        floor: 1,
                        purpose: .majlis,
                        features: ["Traditional seating", "Ornate ceiling", "Crystal chandelier"],
                        ventilation: "Natural cross ventilation",
                        lighting: "Traditional lanterns with LED"
                    )
                ],
                materials: MaterialSuggestion.sampleMaterials + [
                    MaterialSuggestion(
                        name: "Traditional Mud Brick",
                        category: .structure,
                        description: "Authentic mud bricks made from local clay, following traditional Najdi construction methods.",
                        benefits: ["Historical authenticity", "Natural insulation", "Local materials", "Cultural heritage"],
                        estimatedCost: 180,
                        durability: "Good",
                        sustainability: "Excellent",
                        localAvailability: true
                    )
                ],
                budget: BudgetEstimate(
                    total: 4500000,
                    breakdown: [
                        BudgetCategory(name: "Foundation & Structure", amount: 1350000, percentage: 30.0),
                        BudgetCategory(name: "Exterior & Roofing", amount: 1125000, percentage: 25.0),
                        BudgetCategory(name: "Interior Finishing", amount: 900000, percentage: 20.0),
                        BudgetCategory(name: "Traditional Elements", amount: 675000, percentage: 15.0),
                        BudgetCategory(name: "Landscaping", amount: 225000, percentage: 5.0),
                        BudgetCategory(name: "Smart Home & Systems", amount: 225000, percentage: 5.0)
                    ],
                    currency: "SAR",
                    contingency: 450000,
                    timeline: "12-18 months"
                ),
                images: GeneratedImage.sampleImages
            ),
            AIResult(
                projectName: "Mediterranean Coastal Villa",
                clientName: "Al Rashid Family",
                location: "Jeddah, Saudi Arabia",
                plotSize: 1500,
                totalArea: 650,
                floors: 2,
                style: .mediterranean,
                summary: ArchitectureSummary(
                    concept: "Luxury Mediterranean villa with coastal views and modern amenities.",
                    keyFeatures: [
                        "Sea-facing terraces",
                        "Infinity pool",
                        "Outdoor living spaces",
                        "Coastal-inspired interiors"
                    ],
                    sustainabilityScore: 0.80,
                    energyEfficiency: "Grade A - Solar panels with energy storage",
                    climateAdaptation: "Natural ventilation with sea breeze optimization",
                    culturalElements: [
                        "Mediterranean aesthetics",
                        "Coastal design elements",
                        "Modern Saudi luxury",
                        "Beach lifestyle integration"
                    ]
                ),
                rooms: Room.sampleRooms,
                materials: MaterialSuggestion.sampleMaterials,
                budget: BudgetEstimate(
                    total: 3200000,
                    breakdown: [
                        BudgetCategory(name: "Foundation & Structure", amount: 960000, percentage: 30.0),
                        BudgetCategory(name: "Exterior & Roofing", amount: 800000, percentage: 25.0),
                        BudgetCategory(name: "Interior Finishing", amount: 640000, percentage: 20.0),
                        BudgetCategory(name: "Kitchen & Bathrooms", amount: 480000, percentage: 15.0),
                        BudgetCategory(name: "Pool & Landscaping", amount: 160000, percentage: 5.0),
                        BudgetCategory(name: "Smart Home & Systems", amount: 160000, percentage: 5.0)
                    ],
                    currency: "SAR",
                    contingency: 320000,
                    timeline: "10-14 months"
                ),
                images: GeneratedImage.sampleImages
            )
        ]
        
        savedProjects.append(contentsOf: sampleProjects)
        saveToUserDefaults()
    }
}
