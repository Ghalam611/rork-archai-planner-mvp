//
//  MetricCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct MetricCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Theme.gold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.62))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.white.opacity(0.07), in: .rect(cornerRadius: 20))
    }
}
