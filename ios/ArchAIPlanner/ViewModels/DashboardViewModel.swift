//
//  DashboardViewModel.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

enum DashboardRoute: Hashable {
    case generate
    case voice
    case land
    case cultural
    case redesign
    case saved
    case chat
}

struct DashboardFeature: Identifiable {
    let id: DashboardRoute
    let title: String
    let subtitle: String
    let icon: String
    let accent: [Color]
    let tag: String
}

extension DashboardFeature {
    static let all: [DashboardFeature] = [
        .init(id: .generate, title: "Generate Design", subtitle: "AI-crafted villa concepts from your brief", icon: "wand.and.stars", accent: [Color(red: 0.98, green: 0.78, blue: 0.36), Color(red: 0.55, green: 0.32, blue: 0.08)], tag: "CORE"),
        .init(id: .voice, title: "Voice Design", subtitle: "Speak your dream, ArchAI drafts the plan", icon: "waveform.circle.fill", accent: [Color(red: 0.62, green: 0.88, blue: 1.0), Color(red: 0.18, green: 0.32, blue: 0.62)], tag: "NEW"),
        .init(id: .land, title: "Empty Land Vision", subtitle: "Visualize a future build on real land", icon: "photo.stack", accent: [Color(red: 0.78, green: 1.0, blue: 0.72), Color(red: 0.18, green: 0.42, blue: 0.28)], tag: "AR"),
        .init(id: .cultural, title: "Cultural Architecture", subtitle: "Najdi, Andalusian, Japandi, Moroccan", icon: "building.columns.fill", accent: [Color(red: 0.96, green: 0.66, blue: 0.86), Color(red: 0.42, green: 0.16, blue: 0.45)], tag: "STYLE"),
        .init(id: .redesign, title: "Redesign AI", subtitle: "Transform any photo into a new style", icon: "sparkles.rectangle.stack.fill", accent: [Color(red: 1.0, green: 0.74, blue: 0.62), Color(red: 0.55, green: 0.18, blue: 0.22)], tag: "PRO"),
        .init(id: .saved, title: "Saved Projects", subtitle: "Your archive of concepts & blueprints", icon: "square.stack.3d.up.fill", accent: [Color(red: 0.88, green: 0.84, blue: 0.74), Color(red: 0.32, green: 0.28, blue: 0.18)], tag: "VAULT"),
        .init(id: .chat, title: "AI Chat Assistant", subtitle: "Ask the AI architect anything, anytime", icon: "bubble.left.and.text.bubble.right.fill", accent: [Color(red: 0.74, green: 0.78, blue: 1.0), Color(red: 0.22, green: 0.18, blue: 0.55)], tag: "AI")
    ]
}
