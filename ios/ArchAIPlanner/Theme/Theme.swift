//
//  Theme.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

enum Theme {
    static let gold = Color(red: 0.86, green: 0.68, blue: 0.34)
    static let goldGradient = LinearGradient(colors: [Color(red: 0.98, green: 0.86, blue: 0.52), Color(red: 0.65, green: 0.45, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cardGradient = LinearGradient(colors: [.white.opacity(0.10), .white.opacity(0.045)], startPoint: .topLeading, endPoint: .bottomTrailing)
}
