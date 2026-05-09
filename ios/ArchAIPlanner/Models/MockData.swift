//
//  MockData.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

// MARK: - Mock Data Provider
struct MockData {
    
    // MARK: - Premium Design Projects
    static let projects: [DesignProject] = [
        DesignProject(
            id: UUID(),
            title: "Royal Najdi Courtyard Estate",
            style: "Modern Najdi Luxury with Traditional Elements",
            landSize: "1,200 sqm",
            floors: "3",
            bedrooms: "7",
            createdAt: Date().addingTimeInterval(-86400), // 1 day ago
            result: DesignResult(
                spaceDistribution: "Ground floor: grand entrance hall with double-height ceiling, formal men's majlis with private entrance, family living area facing central courtyard, women's majlis connected through elegant transition, service core with modern kitchen and staff quarters. Second floor: master bedroom suite with private terrace, three additional bedrooms, family lounge, and library. Third floor: rooftop entertainment deck with panoramic views.",
                roomLayout: "Create U-shaped layout around central courtyard with water feature and traditional mashrabiya design. Separate guest circulation through dedicated corridor with privacy screens. Use double-height spaces for dramatic effect. Place service areas at rear for discreet operation.",
                entranceIdeas: "Majestic entrance with royal gold archway, intricate geometric patterns in stone, bronze-clad doors with traditional hardware, reflecting pool with floating stepping stones, and separate ceremonial guest entrance with grand porte-cochère. Family entrance through shaded garden path with traditional lantern lighting.",
                styleDescription: "Luxurious fusion of traditional Najdi architecture with contemporary luxury materials. Features warm limestone facades with gold inlay, bronze mashrabiya screens for privacy, deep shadow lines for dramatic effect, and floor-to-ceiling windows overlooking courtyard. Interior combines traditional arabesque patterns with modern minimalism.",
                improvements: "Incorporate traditional wind towers for natural cooling, install smart glass facades that can transition from transparent to opaque, add rooftop garden with traditional irrigation system, and create underground parking with elevator access."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Andalusian Heritage Palace",
            style: "Classic Andalusian with Modern Luxury",
            landSize: "1,500 sqm",
            floors: "3",
            bedrooms: "8",
            createdAt: Date().addingTimeInterval(-172800), // 2 days ago
            result: DesignResult(
                spaceDistribution: "Ground floor: grand double-height entrance hall with fountain, formal reception rooms, library with traditional arabesque ceiling, and ceremonial spaces. First floor: family living areas with indoor-outdoor flow, dining room with terrace access, and informal family areas. Second floor: master suite with private courtyard view, guest bedrooms with en-suite bathrooms, and family lounge.",
                roomLayout: "Organize around central courtyard with traditional Andalusian garden featuring geometric patterns, water channels, and citrus trees. Create hierarchical circulation with grand central staircase and service elevators. Use traditional patio spaces for climate control. Maintain clear separation between public and private family areas.",
                entranceIdeas: "Grand horseshoe archway with intricate geometric tilework, carved cedar doors with bronze knockers, reflecting pool with mosaic tiles, and traditional lantern lighting. Side entrance through garden path with traditional water features and shaded seating areas.",
                styleDescription: "Magnificent interpretation of Andalusian palace architecture with modern luxury amenities. Features intricate stucco facades with arabesque patterns, horseshoe arches throughout, ornate tilework with traditional motifs, carved wooden ceilings, and interior courtyards with water features. Gold accents highlight traditional architectural elements.",
                improvements: "Install traditional cooling systems using wind towers and water channels, maximize natural ventilation through strategically placed windows, add solar tiles on roof that blend with traditional design, and create rainwater harvesting system for traditional gardens."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Modern Islamic Heritage Villa",
            style: "Contemporary Islamic Architecture",
            landSize: "800 sqm",
            floors: "2",
            bedrooms: "5",
            createdAt: Date().addingTimeInterval(-259200), // 3 days ago
            result: DesignResult(
                spaceDistribution: "Ground floor: open-plan living area with double-height space, formal dining room with traditional mashrabiya screens, modern kitchen with island, guest bedroom suite, and prayer room. Second floor: master bedroom with private terrace, three additional bedrooms, family lounge, and home office with balcony access.",
                roomLayout: "Create L-shaped layout with central atrium bringing natural light throughout. Use sliding panels for flexible space division. Incorporate traditional geometric patterns in modern interpretation. Maintain clear sight lines between spaces while respecting traditional privacy requirements.",
                entranceIdeas: "Modern interpretation of traditional entrance with geometric patterns in stone and glass, grand wooden doors with traditional hardware in contemporary finish, water feature with modern fountain design, and integrated landscape lighting. Separate service entrance with discreet access.",
                styleDescription: "Contemporary interpretation of Islamic architectural principles with modern materials and technology. Features clean geometric patterns, abundant natural light, sustainable materials, and smart home integration while respecting traditional design vocabulary.",
                improvements: "Incorporate passive cooling through traditional courtyard design, use smart glass that can provide privacy when needed, install solar panels in traditional patterns, and create indoor-outdoor living spaces that respect cultural requirements."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Desert Modern Oasis",
            style: "Sustainable Desert Architecture",
            landSize: "1,000 sqm",
            floors: "2",
            bedrooms: "6",
            createdAt: Date().addingTimeInterval(-345600), // 4 days ago
            result: DesignResult(
                spaceDistribution: "Ground floor: living area with desert views, modern kitchen with large island, dining room with terrace, guest suite, and indoor garden with native desert plants. Second floor: master bedroom suite with private desert garden terrace, four additional bedrooms, family lounge, and home theater.",
                roomLayout: "Create H-shaped layout maximizing desert views from all major rooms. Use thick walls for thermal mass and natural cooling. Incorporate traditional courtyard elements for climate control. Design indoor-outdoor flow for desert lifestyle.",
                entranceIdeas: "Modern entrance inspired by desert dunes with flowing lines, natural stone materials, integrated water feature representing oasis, and landscape lighting that creates dramatic nighttime effect. Use traditional shading devices in contemporary interpretation.",
                styleDescription: "Sustainable luxury architecture inspired by desert landscapes and traditional oasis design. Features earth-toned materials, natural cooling systems, solar integration, and water conservation while maintaining modern luxury aesthetic. Gold accents used sparingly for elegant emphasis.",
                improvements: "Install advanced water recycling and desalination systems, use phase-change materials for thermal regulation, incorporate traditional wind catchers in modern design, and create rooftop garden with desert vegetation for insulation."
            )
        ),
        DesignProject(
            id: UUID(),
            title: "Gulf Contemporary Mansion",
            style: "Ultra-Modern Gulf Luxury",
            landSize: "2,000 sqm",
            floors: "4",
            bedrooms: "9",
            createdAt: Date().addingTimeInterval(-432000), // 5 days ago
            result: DesignResult(
                spaceDistribution: "Basement: luxury entertainment center, wine cellar, gym, and service areas. Ground floor: grand entrance with triple-height atrium, formal reception areas, gallery space, and indoor pool. Second floor: family living areas with garden access, formal dining room, and informal spaces. Third floor: master suite with private elevator, additional bedrooms, and family lounge. Fourth floor: rooftop terrace with infinity pool and panoramic views.",
                roomLayout: "Create dramatic vertical circulation with grand central staircase, glass elevator, and multiple level connections. Use double-height spaces for luxury effect. Incorporate indoor-outdoor flow throughout multiple levels. Design separate wings for different family functions while maintaining architectural cohesion.",
                entranceIdeas: "Spectacular entrance with glass canopy, water walls, and dramatic lighting. Grand bronze doors with modern security systems. Circular driveway with fountain feature and landscape lighting. Service entrance with discreet access and loading areas.",
                styleDescription: "Cutting-edge contemporary architecture incorporating Gulf cultural elements with ultra-modern luxury. Features glass facades with dynamic lighting, smart home systems, infinity pools, and sustainable materials. Gold accents used for dramatic effect and cultural significance.",
                improvements: "Install advanced home automation systems, incorporate sustainable energy generation, use water recycling and treatment systems, create vertical gardens on multiple levels, and implement advanced security and climate control systems."
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
