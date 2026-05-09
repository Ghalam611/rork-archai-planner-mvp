//
//  GalleryView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct GalleryView: View {
    let projects: [DesignProject]

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBlock(title: "Saved Projects", subtitle: "A visual archive of saved generated concepts.")
                    if projects.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "square.stack.3d.up")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.gold.opacity(0.7))
                            Text("No saved concepts yet")
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        ForEach(projects) { project in
                            BlueprintCard(project: project)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Saved Projects")
        .navigationBarTitleDisplayMode(.inline)
    }
}
