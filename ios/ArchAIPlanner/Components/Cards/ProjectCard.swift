//
//  ProjectCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ProjectCard: View {
    let project: DesignProject

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(project.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("\(project.landSize) • \(project.floors) floors • \(project.bedrooms) bedrooms")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.gold)
            }
            Text(project.result.styleDescription)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.76))
                .lineLimit(3)
        }
        .padding(18)
        .background(Theme.cardGradient, in: .rect(cornerRadius: 24))
        .overlay(Theme.gold.opacity(0.25), in: .rect(cornerRadius: 24).stroke(lineWidth: 1))
    }
}
