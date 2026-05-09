//
//  DesignResult.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

nonisolated struct DesignResult: Hashable, Codable {
    let spaceDistribution: String
    let roomLayout: String
    let entranceIdeas: String
    let styleDescription: String
    let improvements: String

    static let sample = DesignResult(
        spaceDistribution: "Ground floor: formal men's majlis near a private guest entry, family living facing the garden, women's majlis connected to dining, service core placed discreetly behind the kitchen. Upper floor: bedroom suites arranged around a quiet family lounge.",
        roomLayout: "Create a central courtyard spine with visual access from living, dining, and circulation. Keep guest, family, and service zones separated for privacy and smooth movement.",
        entranceIdeas: "A recessed gold-lit portal with stone fins, separate ceremonial guest door, and shaded family entry beside a planted arrival court.",
        styleDescription: "A refined blend of warm limestone, bronze screens, deep shadow lines, and minimal AI-optimized proportions inspired by Gulf contemporary architecture.",
        improvements: "Add cross-ventilation corridors, solar shading on west facades, a service yard behind the kitchen, and flexible room dimensions for future expansion."
    )
}
