//
//  DesignPrompt.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

struct DesignPrompt: Codable {
    let landSize: String
    let floors: String
    let bedrooms: String
    let menMajlis: Bool
    let womenMajlis: Bool
    let garden: Bool
    let pool: Bool
    let style: String
    let requirements: String
}
