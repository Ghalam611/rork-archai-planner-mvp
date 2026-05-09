//
//  DashboardCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct DashboardCard: View {
    let feature: DashboardFeature
    let index: Int
    @State private var shimmer: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                LinearGradient(colors: feature.accent, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.85)

                // Shimmer sweep
                LinearGradient(colors: [.white.opacity(0), .white.opacity(0.35), .white.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .blendMode(.plusLighter)
                    .rotationEffect(.degrees(20))
                    .offset(x: shimmer ? 160 : -160)
                    .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: false).delay(Double(index) * 0.3), value: shimmer)

                // Glyph background
                Image(systemName: feature.icon)
                    .font(.system(size: 110, weight: .bold))
                    .foregroundStyle(.white.opacity(0.10))
                    .offset(x: 30, y: 24)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: feature.icon)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 38, height: 38)
                            .background(.white.opacity(0.18), in: .circle)
                            .overlay(.white.opacity(0.35), in: .circle.stroke(lineWidth: 1))
                        Spacer()
                        Text(feature.tag)
                            .font(.system(size: 9, weight: .heavy))
                            .tracking(1.2)
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.85), in: .rect(cornerRadius: 6))
                    }
                    Spacer(minLength: 0)
                }
                .padding(14)
            }
            .frame(height: 110)
            .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text(feature.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text(feature.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 4) {
                    Text("Open")
                        .font(.caption.weight(.semibold))
                    Image(systemName: "arrow.up.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(Theme.gold)
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
        }
        .background(.white.opacity(0.05))
        .clipShape(.rect(cornerRadius: 22))
        .overlay(.white.opacity(0.10), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))
        .shadow(color: feature.accent.first?.opacity(0.25) ?? .clear, radius: 18, x: 0, y: 10)
        .onAppear { shimmer = true }
    }
}
