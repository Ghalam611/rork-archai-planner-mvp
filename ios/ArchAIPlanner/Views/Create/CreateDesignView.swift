//
//  CreateDesignView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct CreateDesignView: View {
    @Bindable var appState: AppState
    @State private var landSize: String = "750 sqm"
    @State private var floors: String = "2"
    @State private var bedrooms: String = "5"
    @State private var menMajlis: Bool = true
    @State private var womenMajlis: Bool = true
    @State private var garden: Bool = true
    @State private var pool: Bool = false
    @State private var style: String = "Contemporary Gulf Luxury"
    @State private var requirements: String = "Private family zones, shaded outdoor seating, and impressive guest arrival."
    @State private var generatedProject: DesignProject?
    @State private var isGenerating: Bool = false
    @State private var didSave: Bool = false

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBlock(title: "Generate Design", subtitle: "Describe the land and lifestyle. ArchAI drafts a planning direction instantly.")
                    LuxuryTextField(title: "Land size", text: $landSize, icon: "ruler")
                    LuxuryTextField(title: "Number of floors", text: $floors, icon: "building.2")
                    LuxuryTextField(title: "Bedrooms", text: $bedrooms, icon: "bed.double")
                    LuxuryTextField(title: "Architectural style", text: $style, icon: "building.columns")
                    TogglePill(title: "Men's Majlis", isOn: $menMajlis)
                    TogglePill(title: "Women's Majlis", isOn: $womenMajlis)
                    TogglePill(title: "Garden", isOn: $garden)
                    TogglePill(title: "Pool", isOn: $pool)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Special requirements")
                            .foregroundStyle(.white.opacity(0.72))
                        TextEditor(text: $requirements)
                            .frame(minHeight: 110)
                            .scrollContentBackground(.hidden)
                            .padding(10)
                            .background(.white.opacity(0.07), in: .rect(cornerRadius: 18))
                            .foregroundStyle(.white)
                    }

                    Button {
                        generateDesign()
                    } label: {
                        HStack(spacing: 10) {
                            if isGenerating {
                                ProgressView().tint(.black)
                            } else {
                                Image(systemName: "sparkles")
                            }
                            Text(isGenerating ? "Generating concept..." : "Generate architectural plan")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GoldButtonStyle())
                    .disabled(isGenerating)

                    if let generatedProject {
                        ResultPanel(project: generatedProject)
                        SaveProjectButton(didSave: didSave) {
                            appState.save(project: generatedProject)
                            withAnimation(.spring) { didSave = true }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Generate Design")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func generateDesign() {
        isGenerating = true
        didSave = false
        let majlisLine = "Men majlis: \(menMajlis ? "yes" : "no"), women majlis: \(womenMajlis ? "yes" : "no"), garden: \(garden ? "yes" : "no"), pool: \(pool ? "yes" : "no")."
        let result = DesignResult(
            spaceDistribution: "Allocate \(landSize) into a formal guest zone, protected family zone, and service zone. With \(floors) floors and \(bedrooms) bedrooms, place public hospitality on ground level and private suites upstairs. \(majlisLine)",
            roomLayout: "Use a grand arrival axis, then branch into men's majlis near the guest entrance, women's majlis close to dining, family living facing garden views, and bedrooms around a calm upper lounge.",
            entranceIdeas: "Design a deep shaded portal with bronze detailing, concealed lighting, a palm-lined arrival court, and a secondary family entrance for privacy.",
            styleDescription: "\(style) with layered stone volumes, slim gold metal screens, tall white interiors, warm indirect lighting, and a boutique-hotel sense of arrival.",
            improvements: "Prioritize privacy, natural light, shaded west elevations, storage near service areas, acoustic separation for majlis rooms, and future expansion points. Requirements noted: \(requirements)"
        )
        let project = DesignProject(id: UUID(), title: "\(style) Concept", style: style, landSize: landSize, floors: floors, bedrooms: bedrooms, createdAt: Date(), result: result)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.84)) {
                generatedProject = project
                isGenerating = false
            }
        }
    }
}

struct SaveProjectButton: View {
    let didSave: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(didSave ? "Saved to Projects" : "Save to Projects", systemImage: didSave ? "checkmark.seal.fill" : "square.and.arrow.down")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(GoldButtonStyle())
        .disabled(didSave)
    }
}

struct ResultPanel: View {
    let project: DesignProject

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Generated Plan")
                .font(.title2.bold())
                .foregroundStyle(Theme.gold)
            ResultRow(title: "Space distribution", value: project.result.spaceDistribution)
            ResultRow(title: "Suggested room layout", value: project.result.roomLayout)
            ResultRow(title: "Entrance ideas", value: project.result.entranceIdeas)
            ResultRow(title: "Design style", value: project.result.styleDescription)
            ResultRow(title: "Practical improvements", value: project.result.improvements)
        }
        .padding(18)
        .background(.black.opacity(0.38), in: .rect(cornerRadius: 24))
        .overlay(.white.opacity(0.12), in: .rect(cornerRadius: 24).stroke(lineWidth: 1))
    }
}

struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.gold)
            Text(value)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.82))
        }
    }
}

// MARK: - Preview Providers
#Preview("Default") {
    CreateDesignView(appState: MockData.authenticatedAppState)
}

#Preview("With Generated Result") {
    CreateDesignView(appState: MockData.authenticatedAppState)
        .previewDisplayName("With Generated Result")
        .onAppear {
            // Simulate generated result
        }
}

#Preview("Loading State") {
    CreateDesignView(appState: MockData.authenticatedAppState)
        .previewDisplayName("Loading State")
        .onAppear {
            // Simulate loading state
        }
}

#Preview("iPhone 15 Pro") {
    CreateDesignView(appState: MockData.authenticatedAppState)
        .previewDevice(PreviewDevices.iPhone15Pro.name)
}

#Preview("iPhone 15 Pro Max") {
    CreateDesignView(appState: MockData.authenticatedAppState)
        .previewDevice(PreviewDevices.iPhone15ProMax.name)
}

#Preview("iPad Pro") {
    CreateDesignView(appState: MockData.authenticatedAppState)
        .previewDevice(PreviewDevices.iPadPro.name)
}
