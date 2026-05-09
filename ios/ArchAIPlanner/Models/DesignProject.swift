//
//  DesignProject.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

nonisolated struct DesignProject: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let style: String
    let landSize: String
    let floors: String
    let bedrooms: String
    let createdAt: Date
    let result: DesignResult

    static let samples: [DesignProject] = [
        DesignProject(
            id: UUID(),
            title: "Najdi Courtyard Villa",
            style: "Modern Najdi Luxury",
            landSize: "900 sqm",
            floors: "2",
            bedrooms: "5",
            createdAt: Date(),
            result: DesignResult.sample
        )
    ]
}
