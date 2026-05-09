//
//  HeaderBlock.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct HeaderBlock: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.66))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
