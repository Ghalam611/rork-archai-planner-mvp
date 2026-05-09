//
//  BlueprintCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct BlueprintCard: View {
    let project: DesignProject

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.white.opacity(0.10), Theme.gold.opacity(0.18), .black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
            BlueprintLines()
                .stroke(Theme.gold.opacity(0.44), lineWidth: 1.2)
                .padding(26)
            VStack(alignment: .leading, spacing: 6) {
                Text(project.title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text(project.style)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.gold)
            }
            .padding(18)
        }
        .frame(height: 210)
        .clipShape(.rect(cornerRadius: 28))
        .overlay(.white.opacity(0.12), in: .rect(cornerRadius: 28).stroke(lineWidth: 1))
    }
}

struct BlueprintLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: w, height: h))
        path.addRect(CGRect(x: rect.minX + w * 0.08, y: rect.minY + h * 0.10, width: w * 0.38, height: h * 0.35))
        path.addRect(CGRect(x: rect.minX + w * 0.54, y: rect.minY + h * 0.10, width: w * 0.36, height: h * 0.28))
        path.addRect(CGRect(x: rect.minX + w * 0.12, y: rect.minY + h * 0.58, width: w * 0.78, height: h * 0.30))
        path.move(to: CGPoint(x: rect.minX + w * 0.46, y: rect.minY + h * 0.28))
        path.addLine(to: CGPoint(x: rect.minX + w * 0.54, y: rect.minY + h * 0.28))
        return path
    }
}
