import SwiftUI
import PhotosUI
import Combine

// MARK: - Studio Hub

struct StudioView: View {
    @Bindable var appState: AppState
    var body: some View {
        NavigationStack {
            ZStack {
                LuxuryBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        HeaderBlock(
                            title: "AI Studio",
                            subtitle: "Premium architectural intelligence. Voice, vision, culture, and instant redesign."
                        )

                        VStack(spacing: 14) {
                            NavigationLink(value: StudioRoute.silent) {
                                StudioCard(
                                    icon: "waveform.badge.mic",
                                    title: "Silent Designer",
                                    subtitle: "Voice to architecture. Speak your dream building.",
                                    accent: Theme.gold
                                )
                            }
                            NavigationLink(value: StudioRoute.land) {
                                StudioCard(
                                    icon: "viewfinder.circle",
                                    title: "Empty Land Vision",
                                    subtitle: "Capture a land photo. AI overlays a concept building.",
                                    accent: Theme.gold
                                )
                            }
                            NavigationLink(value: StudioRoute.culture) {
                                StudioCard(
                                    icon: "building.columns.fill",
                                    title: "Cultural Architecture",
                                    subtitle: "Najdi, Andalusian, Moroccan, Japanese, Gulf and more.",
                                    accent: Theme.gold
                                )
                            }
                            NavigationLink(value: StudioRoute.redesign) {
                                StudioCard(
                                    icon: "wand.and.rays",
                                    title: "ReDesign From One Photo",
                                    subtitle: "Reimagine any room into Modern, Japandi, Luxury, more.",
                                    accent: Theme.gold
                                )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: StudioRoute.self) { route in
                switch route {
                case .silent: SilentDesignerView(appState: appState)
                case .land: EmptyLandVisionView(appState: appState)
                case .culture: CulturalArchitectureView()
                case .redesign: ReDesignView(appState: appState)
                }
            }
        }
    }
}

enum StudioRoute: Hashable {
    case silent, land, culture, redesign
}

struct StudioCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(accent.opacity(0.18))
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(accent)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.66))
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(accent)
        }
        .padding(16)
        .background(Theme.cardGradient, in: .rect(cornerRadius: 24))
        .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 24).stroke(lineWidth: 1))
    }
}

// MARK: - 1. Silent Designer

struct SilentDesignerView: View {
    @Bindable var appState: AppState
    @State private var isRecording: Bool = false
    @State private var elapsed: Double = 0
    @State private var transcript: String = ""
    @State private var requirements: [String] = []
    @State private var concept: String = ""
    @State private var pulse: Bool = false
    @State private var didSave: Bool = false

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HeaderBlock(
                        title: "Silent Designer",
                        subtitle: "Hold the mic and describe your dream building. AI converts your words into architectural requirements."
                    )

                    VStack(spacing: 18) {
                        ZStack {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .stroke(Theme.gold.opacity(isRecording ? 0.45 - Double(i) * 0.12 : 0.15), lineWidth: 1.4)
                                    .frame(width: 160 + CGFloat(i) * 40, height: 160 + CGFloat(i) * 40)
                                    .scaleEffect(pulse ? 1.08 : 0.92)
                                    .animation(
                                        .easeInOut(duration: 1.4).repeatForever().delay(Double(i) * 0.18),
                                        value: pulse
                                    )
                            }
                            Button {
                                toggleRecording()
                            } label: {
                                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundStyle(.black)
                                    .frame(width: 130, height: 130)
                                    .background(Theme.goldGradient, in: .circle)
                                    .shadow(color: Theme.gold.opacity(0.55), radius: 28, y: 8)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(height: 280)

                        Text(isRecording ? String(format: "Listening %.1fs", elapsed) : "Tap to speak")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(Theme.gold)

                        WaveformView(active: isRecording)
                            .frame(height: 48)
                            .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.white.opacity(0.05), in: .rect(cornerRadius: 28))
                    .overlay(.white.opacity(0.10), in: .rect(cornerRadius: 28).stroke(lineWidth: 1))

                    if !transcript.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TRANSCRIPT")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.gold)
                            Text(transcript)
                                .foregroundStyle(.white.opacity(0.86))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white.opacity(0.06), in: .rect(cornerRadius: 22))
                    }

                    if !requirements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Extracted Requirements")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            ForEach(requirements, id: \.self) { req in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "sparkle")
                                        .foregroundStyle(Theme.gold)
                                    Text(req)
                                        .foregroundStyle(.white.opacity(0.84))
                                }
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardGradient, in: .rect(cornerRadius: 22))
                        .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))
                    }

                    if !concept.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("AI CONCEPT")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.gold)
                            Text(concept)
                                .foregroundStyle(.white.opacity(0.88))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black.opacity(0.4), in: .rect(cornerRadius: 22))
                        .overlay(.white.opacity(0.10), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))

                        SaveProjectButton(didSave: didSave) {
                            let result = DesignResult(
                                spaceDistribution: requirements.joined(separator: " · "),
                                roomLayout: concept,
                                entranceIdeas: "Ceremonial guest portal with separate family entry, defined by voice brief.",
                                styleDescription: "Voice-described concept rendered into Gulf luxury sensibility.",
                                improvements: "Refine acoustic separation between majlis and family wings, add courtyard ventilation."
                            )
                            let project = DesignProject(
                                id: UUID(),
                                title: "Voice Concept",
                                style: "Voice Designer",
                                landSize: "—",
                                floors: "2",
                                bedrooms: "4",
                                createdAt: Date(),
                                result: result
                            )
                            appState.save(project: project)
                            withAnimation(.spring) { didSave = true }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Silent Designer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { pulse = true }
        .onReceive(timer) { _ in
            if isRecording { elapsed += 0.1 }
        }
    }

    private func toggleRecording() {
        if isRecording {
            isRecording = false
            simulateInterpretation()
        } else {
            isRecording = true
            elapsed = 0
            transcript = ""
            requirements = []
            concept = ""
            didSave = false
        }
    }

    private func simulateInterpretation() {
        // Placeholder voice-to-architecture pipeline.
        // In production, hook to Speech.framework + AIService.
        transcript = "I want a two floor villa with a private men's majlis, a calm garden, four bedrooms, and a Gulf luxury feeling with warm stone."
        requirements = [
            "Two floors, ~600–800 sqm footprint",
            "Private men's majlis with separate guest entrance",
            "Four bedrooms, family lounge upstairs",
            "Landscaped courtyard garden",
            "Gulf luxury aesthetic — warm stone, bronze accents"
        ]
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            concept = "AI proposes a U-shaped plan wrapping a private courtyard. The men's majlis sits forward with its own arrival portal, while family rooms open to the rear garden. Limestone cladding, slim bronze screens, and warm indirect lighting deliver a contemporary Gulf luxury identity."
        }
    }
}

struct WaveformView: View {
    let active: Bool
    @State private var phase: Double = 0
    private let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 4) {
                ForEach(0..<28, id: \.self) { i in
                    let h = active
                        ? (sin(phase + Double(i) * 0.5) * 0.5 + 0.5) * geo.size.height
                        : geo.size.height * 0.18
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.goldGradient)
                        .frame(width: (geo.size.width - 27 * 4) / 28, height: max(4, h))
                }
            }
            .frame(maxHeight: .infinity)
        }
        .onReceive(timer) { _ in
            if active { phase += 0.32 }
        }
    }
}

// MARK: - 2. AI Empty Land Vision

struct EmptyLandVisionView: View {
    @Bindable var appState: AppState
    @State private var pickerItem: PhotosPickerItem?
    @State private var landImage: Image?
    @State private var isProcessing: Bool = false
    @State private var conceptReady: Bool = false
    @State private var selectedStyle: String = "Futuristic Saudi"
    @State private var didSave: Bool = false

    private let styles = ["Futuristic Saudi", "Najdi", "Andalusian", "Gulf Luxury"]

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderBlock(
                        title: "Empty Land Vision",
                        subtitle: "Upload or capture an empty plot. AI overlays a futuristic concept building tailored to its terrain."
                    )

                    Color(.secondarySystemBackground)
                        .frame(height: 260)
                        .overlay {
                            if let landImage {
                                landImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .allowsHitTesting(false)
                            } else {
                                LandPlaceholder()
                                    .allowsHitTesting(false)
                            }
                        }
                        .overlay {
                            if conceptReady {
                                ConceptOverlay(style: selectedStyle)
                                    .allowsHitTesting(false)
                                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
                            }
                        }
                        .clipShape(.rect(cornerRadius: 24))
                        .overlay(Theme.gold.opacity(0.3), in: .rect(cornerRadius: 24).stroke(lineWidth: 1))

                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label(landImage == nil ? "Upload land photo" : "Replace photo", systemImage: "photo.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GoldButtonStyle())
                    .onChange(of: pickerItem) { _, newItem in
                        loadImage(from: newItem)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Concept style")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.gold)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(styles, id: \.self) { s in
                                    Button {
                                        selectedStyle = s
                                    } label: {
                                        Text(s)
                                            .font(.callout.weight(.semibold))
                                            .foregroundStyle(selectedStyle == s ? .black : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedStyle == s
                                                ? AnyShapeStyle(Theme.goldGradient)
                                                : AnyShapeStyle(Color.white.opacity(0.08)),
                                                in: .capsule
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .contentMargins(.horizontal, 0)
                    }

                    Button {
                        visualize()
                    } label: {
                        Label(isProcessing ? "Generating concept..." : "Visualize on Land", systemImage: "sparkles.rectangle.stack")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GoldButtonStyle())
                    .disabled(isProcessing)

                    if conceptReady {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AI Concept Notes")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            Text("ArchAI estimates a building footprint of ~38% of the land, oriented to reduce western sun exposure. Volumes step back toward the rear to preserve view corridors. \(selectedStyle) cues are applied in cladding, openings, and skyline silhouette.")
                                .foregroundStyle(.white.opacity(0.82))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardGradient, in: .rect(cornerRadius: 22))
                        .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))

                        SaveProjectButton(didSave: didSave) {
                            let result = DesignResult(
                                spaceDistribution: "Concept footprint ~38% of land area, optimized for sun and view.",
                                roomLayout: "Volumes step back toward the rear to preserve view corridors.",
                                entranceIdeas: "Sheltered ceremonial arrival flanked by stone fins and integrated planting.",
                                styleDescription: "\(selectedStyle) silhouette translated to the actual plot.",
                                improvements: "Validate setbacks, drainage, and orientation on site."
                            )
                            let project = DesignProject(
                                id: UUID(),
                                title: "\(selectedStyle) on Land",
                                style: selectedStyle,
                                landSize: "From photo",
                                floors: "2",
                                bedrooms: "—",
                                createdAt: Date(),
                                result: result
                            )
                            appState.save(project: project)
                            withAnimation(.spring) { didSave = true }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Empty Land Vision")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    landImage = Image(uiImage: uiImage)
                    conceptReady = false
                }
            }
        }
    }

    private func visualize() {
        isProcessing = true
        conceptReady = false
        didSave = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.84)) {
                conceptReady = true
                isProcessing = false
            }
        }
    }
}

struct LandPlaceholder: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.18, green: 0.16, blue: 0.12), Color(red: 0.32, green: 0.26, blue: 0.18)],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 8) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 38))
                    .foregroundStyle(Theme.gold.opacity(0.7))
                Text("Empty land preview")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}

struct ConceptOverlay: View {
    let style: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.35)],
                startPoint: .top, endPoint: .bottom
            )
            // Stylized concept building silhouette
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                Path { p in
                    p.move(to: CGPoint(x: w * 0.18, y: h * 0.95))
                    p.addLine(to: CGPoint(x: w * 0.18, y: h * 0.55))
                    p.addLine(to: CGPoint(x: w * 0.34, y: h * 0.42))
                    p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.55))
                    p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.34))
                    p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.34))
                    p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.62))
                    p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.62))
                    p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.95))
                    p.closeSubpath()
                }
                .fill(LinearGradient(colors: [Theme.gold.opacity(0.55), .black.opacity(0.65)], startPoint: .top, endPoint: .bottom))
                .overlay(
                    Path { p in
                        p.move(to: CGPoint(x: w * 0.18, y: h * 0.55))
                        p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.55))
                    }
                    .stroke(Theme.gold.opacity(0.6), lineWidth: 1)
                )
            }
            VStack {
                Spacer()
                HStack {
                    Text(style.uppercased())
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Theme.goldGradient, in: .capsule)
                    Spacer()
                    Text("AI CONCEPT")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.55), in: .capsule)
                }
                .padding(12)
            }
        }
    }
}

// MARK: - 3. Cultural Architecture

struct CulturalArchitectureView: View {
    @State private var selected: CultureStyle?

    private let cultures: [CultureStyle] = [
        CultureStyle(
            name: "Najdi",
            tagline: "Earthen mass, triangular crowns",
            philosophy: "Shaped by central Arabian climate and tribal life: thick mud walls, narrow openings, and tight courtyards for shade and privacy.",
            materials: "Sun-dried mud brick, palm wood, tamarisk beams, lime plaster, triangular roof crenellations.",
            palette: [Color(red: 0.78, green: 0.55, blue: 0.30), Color(red: 0.45, green: 0.30, blue: 0.18), Color(red: 0.95, green: 0.86, blue: 0.62)],
            symbol: "triangle.fill"
        ),
        CultureStyle(
            name: "Japanese",
            tagline: "Silence, wood, light shadow",
            philosophy: "Wabi-sabi and ma — the appreciation of negative space. Architecture frames nature, with sliding screens and tatami rhythm.",
            materials: "Cedar, hinoki wood, washi paper screens, tatami, blackened timber, raked stone gardens.",
            palette: [Color(red: 0.20, green: 0.20, blue: 0.20), Color(red: 0.55, green: 0.42, blue: 0.30), Color(red: 0.92, green: 0.90, blue: 0.86)],
            symbol: "leaf.fill"
        ),
        CultureStyle(
            name: "Andalusian",
            tagline: "Patios, water, geometry",
            philosophy: "Islamic Iberian fusion. Cool inner patios with citrus trees, flowing fountains, and intricate tilework speaking to paradise gardens.",
            materials: "Glazed zellige tile, carved plaster, horseshoe arches, cypress wood, wrought iron grilles.",
            palette: [Color(red: 0.90, green: 0.85, blue: 0.78), Color(red: 0.10, green: 0.34, blue: 0.40), Color(red: 0.78, green: 0.30, blue: 0.22)],
            symbol: "drop.fill"
        ),
        CultureStyle(
            name: "Moroccan",
            tagline: "Riad courtyards, jewel tones",
            philosophy: "Inward-facing riads turn their back to the street and open to a lush central courtyard — a private oasis of sound and light.",
            materials: "Tadelakt plaster, zellige mosaic, carved cedar ceilings, brass lanterns, hand-laid bejmat floor tiles.",
            palette: [Color(red: 0.80, green: 0.30, blue: 0.20), Color(red: 0.05, green: 0.30, blue: 0.30), Color(red: 0.95, green: 0.78, blue: 0.30)],
            symbol: "star.fill"
        ),
        CultureStyle(
            name: "Gulf Luxury",
            tagline: "Stone, bronze, hospitality",
            philosophy: "Hospitality is the brief: ceremonial arrival, separate majlis, and grand interior volumes balanced with private family realms.",
            materials: "Limestone, travertine, brushed bronze screens, smoked oak, polished plaster, layered indirect lighting.",
            palette: [Color(red: 0.92, green: 0.86, blue: 0.74), Color(red: 0.65, green: 0.45, blue: 0.20), Color(red: 0.12, green: 0.10, blue: 0.08)],
            symbol: "crown.fill"
        ),
        CultureStyle(
            name: "Futuristic Saudi",
            tagline: "Neom-era silhouettes",
            philosophy: "Vision-2030 sensibility: parametric facades, mirrored volumes, desert resilience, and AI-aware sustainable systems.",
            materials: "Mirror-finish steel, photovoltaic glass, parametric GRC panels, sand-toned concrete, kinetic shading fins.",
            palette: [Color(red: 0.10, green: 0.12, blue: 0.18), Color(red: 0.85, green: 0.70, blue: 0.40), Color(red: 0.65, green: 0.85, blue: 0.95)],
            symbol: "sparkles"
        )
    ]

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBlock(
                        title: "Cultural Architecture",
                        subtitle: "Six rich design languages. Tap a culture to read its philosophy and signature materials."
                    )
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(cultures) { culture in
                            Button {
                                selected = culture
                            } label: {
                                CultureCard(culture: culture)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Cultural Architecture")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selected) { culture in
            CultureDetailView(culture: culture)
        }
    }
}

struct CultureStyle: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let tagline: String
    let philosophy: String
    let materials: String
    let palette: [Color]
    let symbol: String
}

struct CultureCard: View {
    let culture: CultureStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                LinearGradient(colors: culture.palette, startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: culture.symbol)
                    .font(.system(size: 30))
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(radius: 8)
            }
            .frame(height: 120)
            .clipShape(.rect(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 4) {
                Text(culture.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(culture.tagline)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.66))
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(Theme.cardGradient, in: .rect(cornerRadius: 22))
        .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))
    }
}

struct CultureDetailView: View {
    let culture: CultureStyle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(colors: culture.palette, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 220)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(culture.name)
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                        Text(culture.tagline)
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(20)
                }
                .clipShape(.rect(cornerRadius: 24))

                CultureSection(title: "Philosophy", text: culture.philosophy)
                CultureSection(title: "Materials & Details", text: culture.materials)

                VStack(alignment: .leading, spacing: 8) {
                    Text("PALETTE")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.gold)
                    HStack(spacing: 10) {
                        ForEach(Array(culture.palette.enumerated()), id: \.offset) { _, c in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(c)
                                .frame(height: 56)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(20)
        }
        .background(LuxuryBackground())
        .presentationDetents([.large])
    }
}

struct CultureSection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.gold)
            Text(text)
                .foregroundStyle(.white.opacity(0.86))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white.opacity(0.06), in: .rect(cornerRadius: 22))
    }
}

// MARK: - 4. ReDesign From One Photo

struct ReDesignView: View {
    @Bindable var appState: AppState
    @State private var pickerItem: PhotosPickerItem?
    @State private var sourceImage: Image?
    @State private var selectedStyle: ReDesignStyle = .modern
    @State private var isGenerating: Bool = false
    @State private var hasResult: Bool = false
    @State private var didSave: Bool = false

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderBlock(
                        title: "ReDesign Photo",
                        subtitle: "Upload a room or building photo. AI reimagines it in the style you pick."
                    )

                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label(sourceImage == nil ? "Upload a photo" : "Replace photo", systemImage: "photo.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GoldButtonStyle())
                    .onChange(of: pickerItem) { _, newItem in
                        loadImage(from: newItem)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Target style")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.gold)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(ReDesignStyle.allCases, id: \.self) { s in
                                    Button {
                                        selectedStyle = s
                                        if sourceImage != nil { hasResult = false }
                                    } label: {
                                        Text(s.rawValue)
                                            .font(.callout.weight(.semibold))
                                            .foregroundStyle(selectedStyle == s ? .black : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedStyle == s
                                                ? AnyShapeStyle(Theme.goldGradient)
                                                : AnyShapeStyle(Color.white.opacity(0.08)),
                                                in: .capsule
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .contentMargins(.horizontal, 0)
                    }

                    Button {
                        regenerate()
                    } label: {
                        Label(isGenerating ? "Reimagining..." : "Generate redesign", systemImage: "wand.and.stars.inverse")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GoldButtonStyle())
                    .disabled(sourceImage == nil || isGenerating)

                    if sourceImage != nil {
                        VStack(spacing: 14) {
                            BeforeAfterCard(
                                label: "BEFORE",
                                image: sourceImage,
                                tint: nil,
                                styleLabel: nil
                            )
                            BeforeAfterCard(
                                label: "AFTER",
                                image: hasResult ? sourceImage : nil,
                                tint: selectedStyle.tint,
                                styleLabel: hasResult ? selectedStyle.rawValue : nil
                            )
                        }
                    }

                    if hasResult {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("STYLE NOTES")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.gold)
                            Text(selectedStyle.notes)
                                .foregroundStyle(.white.opacity(0.86))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardGradient, in: .rect(cornerRadius: 22))
                        .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))

                        SaveProjectButton(didSave: didSave) {
                            let result = DesignResult(
                                spaceDistribution: "Photo redesign keeps existing volumes and reskins surfaces.",
                                roomLayout: "Layout untouched; finishes restyled to \(selectedStyle.rawValue).",
                                entranceIdeas: "Refresh thresholds with \(selectedStyle.rawValue)-aligned hardware and lighting.",
                                styleDescription: selectedStyle.notes,
                                improvements: "Coordinate floor, wall, ceiling, and lighting in one cohesive palette."
                            )
                            let project = DesignProject(
                                id: UUID(),
                                title: "\(selectedStyle.rawValue) ReDesign",
                                style: selectedStyle.rawValue,
                                landSize: "—",
                                floors: "—",
                                bedrooms: "—",
                                createdAt: Date(),
                                result: result
                            )
                            appState.save(project: project)
                            withAnimation(.spring) { didSave = true }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("ReDesign")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    sourceImage = Image(uiImage: uiImage)
                    hasResult = false
                }
            }
        }
    }

    private func regenerate() {
        guard sourceImage != nil else { return }
        isGenerating = true
        hasResult = false
        didSave = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                hasResult = true
                isGenerating = false
            }
        }
    }
}

enum ReDesignStyle: String, CaseIterable {
    case modern = "Modern"
    case luxury = "Luxury"
    case japandi = "Japandi"
    case minimalist = "Minimalist"
    case gulfLuxury = "Gulf Luxury"

    var tint: Color {
        switch self {
        case .modern: return Color(red: 0.20, green: 0.55, blue: 0.85)
        case .luxury: return Color(red: 0.85, green: 0.70, blue: 0.30)
        case .japandi: return Color(red: 0.55, green: 0.45, blue: 0.35)
        case .minimalist: return Color(red: 0.85, green: 0.85, blue: 0.88)
        case .gulfLuxury: return Color(red: 0.78, green: 0.55, blue: 0.25)
        }
    }

    var notes: String {
        switch self {
        case .modern: return "Crisp white walls, large glazing, polished concrete floors, integrated linear lighting, and minimal hardware."
        case .luxury: return "Layered marble, brushed brass, deep velvet upholstery, statement chandeliers, and bookmatched stone features."
        case .japandi: return "Warm light oak, bone-white plaster, restrained joinery, soft linen textiles, and a quiet, uncluttered atmosphere."
        case .minimalist: return "Pure white volumes, hidden joinery, single-material palettes, and intentional negative space at every threshold."
        case .gulfLuxury: return "Limestone walls, bronze metal screens, Arabic geometric inlays, oversized hospitality areas, and warm indirect lighting."
        }
    }
}

struct BeforeAfterCard: View {
    let label: String
    let image: Image?
    let tint: Color?
    let styleLabel: String?

    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 220)
            .overlay {
                if let image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .allowsHitTesting(false)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 30))
                            .foregroundStyle(Theme.gold)
                        Text("AI render appears here")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .allowsHitTesting(false)
                }
            }
            .overlay {
                if let tint {
                    LinearGradient(colors: [tint.opacity(0.35), .black.opacity(0.25)], startPoint: .top, endPoint: .bottom)
                        .allowsHitTesting(false)
                }
            }
            .clipShape(.rect(cornerRadius: 22))
            .overlay(alignment: .topLeading) {
                Text(label)
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.goldGradient, in: .capsule)
                    .padding(12)
            }
            .overlay(alignment: .bottomTrailing) {
                if let styleLabel {
                    Text(styleLabel.uppercased())
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.55), in: .capsule)
                        .padding(12)
                }
            }
            .overlay(Theme.gold.opacity(0.22), in: .rect(cornerRadius: 22).stroke(lineWidth: 1))
    }
}
