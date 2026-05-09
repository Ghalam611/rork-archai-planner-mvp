//
//  MockData.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

// MARK: - Mock Data Provider
struct MockData {
    
    // MARK: - Design Projects
    static let projects: [DesignProject] = [
        DesignProject(
            id: UUID(),
            title: "Najdi Courtyard Villa",
            style: "Modern Najdi Luxury",
            landSize: "900 sqm",
            floors: "2",
            bedrooms: "5",
            createdAt: Date().addingTimeInterval(-86400), // 1 day ago
            result: DesignResult(
                spaceDistribution: "Ground floor: formal men's majlis near a private guest entry, family living facing the garden, women's majlis connected to dining, service core placed discreetly behind the kitchen. Upper floor: bedroom suites arranged around a quiet family lounge.",
                roomLayout: "Create a central courtyard spine with visual access from living, dining, and circulation. Keep guest, family, and service zones separated for privacy and smooth movement.",
                entranceIdeas: "A recessed gold-lit portal with stone fins, separate ceremonial guest door, and shaded family entry beside a planted arrival court.",
                styleDescription: "A refined blend of warm limestone, bronze screens, deep shadow lines, and minimal AI-optimized proportions inspired by Gulf contemporary architecture.",
                improvements: "Add cross-ventilation corridors, solar shading on west facades, a service yard behind the kitchen, and flexible room dimensions for future expansion."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Andalusian Garden Palace",
            style: "Classic Andalusian Revival",
            landSize: "1200 sqm",
            floors: "3",
            bedrooms: "7",
            createdAt: Date().addingTimeInterval(-172800), // 2 days ago
            result: DesignResult(
                spaceDistribution: "Ground floor: grand entrance hall with double-height ceiling, formal reception rooms, and library. First floor: family living spaces with terrace access. Second floor: master suite and guest bedrooms with private balconies.",
                roomLayout: "Organize around central courtyard with fountain. Place public rooms at front, private family areas in center, service spaces at rear. Create vertical circulation via grand staircase and service elevator.",
                entranceIdeas: "Moorish archway with intricate geometric patterns, carved wooden doors with bronze hardware, and a reflecting pool leading to main entrance. Side entrance for family and service access.",
                styleDescription: "Traditional Andalusian architecture with horseshoe arches, ornate tilework, carved stucco facades, and lush interior courtyards with water features.",
                improvements: "Incorporate passive cooling through wind towers, maximize natural ventilation, add solar panels on roof, and create rainwater harvesting system for gardens."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Japandi Minimalist Retreat",
            style: "Modern Japandi Fusion",
            landSize: "600 sqm",
            floors: "2",
            bedrooms: "4",
            createdAt: Date().addingTimeInterval(-259200), // 3 days ago
            result: DesignResult(
                spaceDistribution: "Ground floor: open-plan living-dining-kitchen with floor-to-ceiling glass walls, meditation room, and guest suite. Upper floor: master bedroom with private terrace, two additional bedrooms, and home office.",
                roomLayout: "Create L-shaped layout around central zen garden. Use sliding shoji screens for flexible space division. Maintain clean sight lines and minimal corridor space.",
                entranceIdeas: "Simple wooden gate with stone pathway, minimalist entrance with hidden door hardware, and a small water basin for ritual purification. Frame view of zen garden from entry.",
                styleDescription: "Harmonious blend of Japanese minimalism and Scandinavian coziness with natural materials, clean lines, neutral color palette, and emphasis on craftsmanship and simplicity.",
                improvements: "Use sustainable bamboo flooring, install smart home automation for climate control, add green roof for insulation, and incorporate passive solar design principles."
            )
        )
    ]
    
    // MARK: - Chat Messages
    static let chatMessages: [ChatBubbleMessage] = [
        ChatBubbleMessage(role: .ai, text: "Hi, I'm your AI architect. Ask me about layouts, privacy, facades, lighting, or material choices."),
        ChatBubbleMessage(role: .user, text: "What's the best layout for a narrow urban lot?"),
        ChatBubbleMessage(role: .ai, text: "For narrow urban lots, consider a vertical layout with basement garage, ground floor living, upper floor bedrooms, and rooftop terrace. Use light wells and skylights to bring natural light deep into the plan."),
        ChatBubbleMessage(role: .user, text: "How can I maximize privacy in a family home?"),
        ChatBubbleMessage(role: .ai, text: "Separate guest circulation with a direct majlis route from entry court, then use a screened transition before family spaces. Keep service paths behind dining and kitchen for clean operation.")
    ]
    
    // MARK: - Dashboard Features
    static let dashboardFeatures: [DashboardFeature] = DashboardFeature.all
    
    // MARK: - Sample App States
    static let authenticatedAppState = {
        let state = AppState()
        state.isAuthenticated = true
        state.userName = "Ahmed Al-Rashid"
        state.projects = projects
        return state
    }()
    
    static let unauthenticatedAppState = {
        let state = AppState()
        state.isAuthenticated = false
        state.userName = "Guest"
        state.projects = []
        return state
    }()
    
    static let emptyProjectsAppState = {
        let state = AppState()
        state.isAuthenticated = true
        state.userName = "Sarah Al-Fahad"
        state.projects = []
        return state
    }()
}

// MARK: - Preview Device Configurations
struct PreviewDevices {
    static let iPhone15Pro = PreviewDevice(
        name: "iPhone 15 Pro",
        displayName: "iPhone 15 Pro"
    )
    
    static let iPhone15ProMax = PreviewDevice(
        name: "iPhone 15 Pro Max",
        displayName: "iPhone 15 Pro Max"
    )
    
    static let iPadPro = PreviewDevice(
        name: "iPad Pro (12.9-inch)",
        displayName: "iPad Pro 12.9\""
    )
    
    static let iPadMini = PreviewDevice(
        name: "iPad mini",
        displayName: "iPad mini"
    )
}

// MARK: - Preview Variants
enum PreviewVariant {
    case light
    case dark
    case loading
    case empty
    case error
    case success
    
    var displayName: String {
        switch self {
        case .light: return "Light Mode"
        case .dark: return "Dark Mode"
        case .loading: return "Loading State"
        case .empty: return "Empty State"
        case .error: return "Error State"
        case .success: return "Success State"
        }
    }
}
