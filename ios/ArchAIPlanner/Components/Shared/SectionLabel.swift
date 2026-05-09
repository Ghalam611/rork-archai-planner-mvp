//
//  SectionLabel.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct SectionLabel: View {
    let title: String
    let caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            Text(caption)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
