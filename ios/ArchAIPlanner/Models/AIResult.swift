//
//  AIResult.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

// MARK: - AI Generated Architecture Result
struct AIResult: Identifiable, Codable {
    let id: UUID
    let projectName: String
    let clientName: String
    let location: String
    let plotSize: Double
    let totalArea: Double
    let floors: Int
    let style: ArchitectureStyle
    let summary: ArchitectureSummary
    let rooms: [Room]
    let materials: [MaterialSuggestion]
    let budget: BudgetEstimate
    let images: [GeneratedImage]
    let timestamp: Date
    let aiConfidence: Double
    let processingTime: TimeInterval
    
    init(
        projectName: String,
        clientName: String,
        location: String,
        plotSize: Double,
        totalArea: Double,
        floors: Int,
        style: ArchitectureStyle,
        summary: ArchitectureSummary,
        rooms: [Room],
        materials: [MaterialSuggestion],
        budget: BudgetEstimate,
        images: [GeneratedImage],
        aiConfidence: Double = 0.95,
        processingTime: TimeInterval = 45.0
    ) {
        self.id = UUID()
        self.projectName = projectName
        self.clientName = clientName
        self.location = location
        self.plotSize = plotSize
        self.totalArea = totalArea
        self.floors = floors
        self.style = style
        self.summary = summary
        self.rooms = rooms
        self.materials = materials
        self.budget = budget
        self.images = images
        self.timestamp = Date()
        self.aiConfidence = aiConfidence
        self.processingTime = processingTime
    }
}

// MARK: - Architecture Style
enum ArchitectureStyle: String, CaseIterable, Codable {
    case modernSaudi = "Modern Saudi"
    case traditionalNajdi = "Traditional Najdi"
    case mediterranean = "Mediterranean"
    case contemporary = "Contemporary"
    case islamic = "Islamic"
    case luxuryVilla = "Luxury Villa"
    case palace = "Palace"
    
    var description: String {
        switch self {
        case .modernSaudi:
            return "Modern interpretation of Saudi architecture with clean lines and traditional elements"
        case .traditionalNajdi:
            return "Authentic Najdi style with mud-brick aesthetics and geometric patterns"
        case .mediterranean:
            return "Coastal Mediterranean with terracotta and white-washed walls"
        case .contemporary:
            return "Minimalist contemporary design with glass and steel elements"
        case .islamic:
            return "Traditional Islamic architecture with domes and arches"
        case .luxuryVilla:
            return "Ultra-luxury villa with premium materials and amenities"
        case .palace:
            return "Grand palace design with ornate details and expansive spaces"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .modernSaudi:
            return Theme.saudiGold
        case .traditionalNajdi:
            return Theme.desertSand
        case .mediterranean:
            return Theme.accentEmerald
        case .contemporary:
            return Theme.steel
        case .islamic:
            return Theme.richMaroon
        case .luxuryVilla:
            return Theme.royalGold
        case .palace:
            return Theme.deepOchre
        }
    }
}

// MARK: - Architecture Summary
struct ArchitectureSummary: Codable {
    let concept: String
    let keyFeatures: [String]
    let sustainabilityScore: Double
    let energyEfficiency: String
    let climateAdaptation: String
    let culturalElements: [String]
    
    var sustainabilityRating: String {
        switch sustainabilityScore {
        case 0.8...1.0: return "Excellent"
        case 0.6..<0.8: return "Good"
        case 0.4..<0.6: return "Moderate"
        default: return "Needs Improvement"
        }
    }
}

// MARK: - Room
struct Room: Identifiable, Codable {
    let id = UUID()
    let name: String
    let area: Double
    let floor: Int
    let purpose: RoomPurpose
    let features: [String]
    let ventilation: String
    let lighting: String
    
    enum RoomPurpose: String, CaseIterable, Codable {
        case living = "Living Room"
        case bedroom = "Bedroom"
        case kitchen = "Kitchen"
        case bathroom = "Bathroom"
        case dining = "Dining Room"
        case office = "Office"
        case majlis = "Majlis"
        case library = "Library"
        case gym = "Gym"
        case pool = "Pool Area"
        case garden = "Garden"
        case garage = "Garage"
        case prayer = "Prayer Room"
        case servant = "Servant Room"
        
        var icon: String {
            switch self {
            case .living: return "sofa.fill"
            case .bedroom: return "bed.double.fill"
            case .kitchen: return "fork.knife"
            case .bathroom: return " bathtub.fill"
            case .dining: return "table.furniture.fill"
            case .office: return "briefcase.fill"
            case .majlis: return "person.3.fill"
            case .library: return "book.fill"
            case .gym: return "dumbbell.fill"
            case .pool: return "water.waves"
            case .garden: return "leaf.fill"
            case .garage: return "car.fill"
            case .prayer: return "star.fill"
            case .servant: return "person.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .living: return Theme.saudiGold
            case .bedroom: return Theme.warmStone
            case .kitchen: return Theme.accentCopper
            case .bathroom: return Theme.glass
            case .dining: return Theme.richMaroon
            case .office: return Theme.steel
            case .majlis: return Theme.royalGold
            case .library: return Theme.deepOchre
            case .gym: return Theme.accentEmerald
            case .pool: return Theme.midnightBlue
            case .garden: return Theme.accentAmber
            case .garage: return Theme.concrete
            case .prayer: return Theme.royalGold
            case .servant: return Theme.warmStone
            }
        }
    }
}

// MARK: - Material Suggestion
struct MaterialSuggestion: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: MaterialCategory
    let description: String
    let benefits: [String]
    let estimatedCost: Double
    let durability: String
    let sustainability: String
    let localAvailability: Bool
    
    enum MaterialCategory: String, CaseIterable, Codable {
        case foundation = "Foundation"
        case structure = "Structure"
        case exterior = "Exterior"
        case interior = "Interior"
        case roofing = "Roofing"
        case flooring = "Flooring"
        case windows = "Windows & Doors"
        case insulation = "Insulation"
        case finishing = "Finishing"
        
        var icon: String {
            switch self {
            case .foundation: return "building.columns.fill"
            case .structure: return "beam.fill"
            case .exterior: return "house.fill"
            case .interior: return "rectangle.3.group.fill"
            case .roofing: return "triangle.fill"
            case .flooring: return "square.fill"
            case .windows: return "rectangle.fill"
            case .insulation: return "shield.fill"
            case .finishing: return "paintbrush.fill"
            }
        }
    }
}

// MARK: - Budget Estimate
struct BudgetEstimate: Codable {
    let total: Double
    let breakdown: [BudgetCategory]
    let currency: String
    let contingency: Double
    let timeline: String
    
    var totalWithContingency: Double {
        total + contingency
    }
    
    var formattedTotal: String {
        String(format: "%.0f %@", total, currency)
    }
    
    var formattedTotalWithContingency: String {
        String(format: "%.0f %@", totalWithContingency, currency)
    }
}

struct BudgetCategory: Identifiable, Codable {
    let id = UUID()
    let name: String
    let amount: Double
    let percentage: Double
    
    var formattedAmount: String {
        String(format: "%.0f", amount)
    }
}

// MARK: - Generated Image
struct GeneratedImage: Identifiable, Codable {
    let id = UUID()
    let type: ImageType
    let description: String
    let url: String?
    let placeholder: String
    let isAI: Bool
    
    enum ImageType: String, CaseIterable, Codable {
        case exterior = "Exterior View"
        case interior = "Interior View"
        case floorPlan = "Floor Plan"
        case elevation = "Elevation"
        case aerial = "Aerial View"
        case night = "Night View"
        case detail = "Architectural Detail"
        
        var icon: String {
            switch self {
            case .exterior: return "house.fill"
            case .interior: return "rectangle.3.group.fill"
            case .floorPlan: return "square.grid.3x3.fill"
            case .elevation: return "triangle.fill"
            case .aerial: return "camera.fill"
            case .night: return "moon.fill"
            case .detail: return "magnifyingglass.fill"
            }
        }
    }
}
