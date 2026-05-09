//
//  LuxuryTextField.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct LuxuryTextField: View {
    let title: String
    @Binding var text: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Theme.gold)
                .frame(width: 22)
            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .foregroundStyle(.white)
        }
        .padding(15)
        .background(.white.opacity(0.07), in: .rect(cornerRadius: 18))
        .overlay(.white.opacity(0.08), in: .rect(cornerRadius: 18).stroke(lineWidth: 1))
    }
}
