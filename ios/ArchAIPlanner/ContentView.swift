import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = AppState()

    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView(appState: appState)
            } else {
                AuthFlowView(appState: appState)
            }
        }
        .preferredColorScheme(.dark)
    }
}

@Observable
final class AppState {
    var isAuthenticated: Bool = false
    var projects: [DesignProject] = DesignProject.samples
    var selectedProject: DesignProject?
    var userName: String = "Founder"

    func save(project: DesignProject) {
        projects.insert(project, at: 0)
        selectedProject = project
    }
}

nonisolated struct DesignProject: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let style: String
    let landSize: String
    let floors: String
    let bedrooms: String
    let createdAt: Date
    let result: DesignResult

    static let samples: [DesignProject] = [
        DesignProject(
            id: UUID(),
            title: "Najdi Courtyard Villa",
            style: "Modern Najdi Luxury",
            landSize: "900 sqm",
            floors: "2",
            bedrooms: "5",
            createdAt: Date(),
            result: DesignResult.sample
        )
    ]
}

nonisolated struct DesignResult: Hashable, Codable {
    let spaceDistribution: String
    let roomLayout: String
    let entranceIdeas: String
    let styleDescription: String
    let improvements: String

    static let sample = DesignResult(
        spaceDistribution: "Ground floor: formal men’s majlis near a private guest entry, family living facing the garden, women’s majlis connected to dining, service core placed discreetly behind the kitchen. Upper floor: bedroom suites arranged around a quiet family lounge.",
        roomLayout: "Create a central courtyard spine with visual access from living, dining, and circulation. Keep guest, family, and service zones separated for privacy and smooth movement.",
        entranceIdeas: "A recessed gold-lit portal with stone fins, separate ceremonial guest door, and shaded family entry beside a planted arrival court.",
        styleDescription: "A refined blend of warm limestone, bronze screens, deep shadow lines, and minimal AI-optimized proportions inspired by Gulf contemporary architecture.",
        improvements: "Add cross-ventilation corridors, solar shading on west facades, a service yard behind the kitchen, and flexible room dimensions for future expansion."
    )
}

struct AuthFlowView: View {
    @Bindable var appState: AppState
    @State private var isSignup: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Spacer(minLength: 56)
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ArchAI")
                            .font(.system(size: 54, weight: .black, design: .serif))
                            .foregroundStyle(Theme.goldGradient)
                        Text("Planner")
                            .font(.system(size: 46, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Text("Generate architectural concepts, early layouts, room distributions, and refined villa ideas with AI.")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.72))
                            .lineSpacing(4)
                    }

                    VStack(spacing: 14) {
                        if isSignup {
                            LuxuryTextField(title: "Full name", text: $name, icon: "person")
                        }
                        LuxuryTextField(title: "Email", text: $email, icon: "envelope")
                        LuxurySecureField(title: "Password", text: $password, icon: "lock")

                        Button {
                            appState.userName = name.isEmpty ? "Founder" : name
                            appState.isAuthenticated = true
                        } label: {
                            Text(isSignup ? "Create account" : "Enter studio")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(GoldButtonStyle())

                        Button {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                isSignup.toggle()
                            }
                        } label: {
                            Text(isSignup ? "Already have an account? Login" : "New here? Create an account")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(Theme.gold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(18)
                    .background(.white.opacity(0.06), in: .rect(cornerRadius: 28))
                    .overlay(.white.opacity(0.12), in: .rect(cornerRadius: 28).stroke(lineWidth: 1))
                }
                .padding(22)
            }
        }
    }
}

struct MainTabView: View {
    @Bindable var appState: AppState

    var body: some View {
        TabView {
            HomeView(appState: appState)
                .tabItem { Label("Home", systemImage: "square.grid.2x2") }
            NavigationStack {
                CreateDesignView(appState: appState)
            }
            .tabItem { Label("Create", systemImage: "wand.and.stars") }
            NavigationStack {
                ChatView(appState: appState)
            }
            .tabItem { Label("Chat", systemImage: "bubble.left.and.text.bubble.right") }
            ProfileView(appState: appState)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(Theme.gold)
        .preferredColorScheme(.dark)
    }
}

enum DashboardRoute: Hashable {
    case generate
    case voice
    case land
    case cultural
    case redesign
    case saved
    case chat
}

struct DashboardFeature: Identifiable {
    let id: DashboardRoute
    let title: String
    let subtitle: String
    let icon: String
    let accent: [Color]
    let tag: String
}

extension DashboardFeature {
    static let all: [DashboardFeature] = [
        .init(id: .generate, title: "Generate Design", subtitle: "AI-crafted villa concepts from your brief", icon: "wand.and.stars", accent: [Color(red: 0.98, green: 0.78, blue: 0.36), Color(red: 0.55, green: 0.32, blue: 0.08)], tag: "CORE"),
        .init(id: .voice, title: "Voice Design", subtitle: "Speak your dream, ArchAI drafts the plan", icon: "waveform.circle.fill", accent: [Color(red: 0.62, green: 0.88, blue: 1.0), Color(red: 0.18, green: 0.32, blue: 0.62)], tag: "NEW"),
        .init(id: .land, title: "Empty Land Vision", subtitle: "Visualize a future build on real land", icon: "photo.stack", accent: [Color(red: 0.78, green: 1.0, blue: 0.72), Color(red: 0.18, green: 0.42, blue: 0.28)], tag: "AR"),
        .init(id: .cultural, title: "Cultural Architecture", subtitle: "Najdi, Andalusian, Japandi, Moroccan", icon: "building.columns.fill", accent: [Color(red: 0.96, green: 0.66, blue: 0.86), Color(red: 0.42, green: 0.16, blue: 0.45)], tag: "STYLE"),
        .init(id: .redesign, title: "Redesign AI", subtitle: "Transform any photo into a new style", icon: "sparkles.rectangle.stack.fill", accent: [Color(red: 1.0, green: 0.74, blue: 0.62), Color(red: 0.55, green: 0.18, blue: 0.22)], tag: "PRO"),
        .init(id: .saved, title: "Saved Projects", subtitle: "Your archive of concepts & blueprints", icon: "square.stack.3d.up.fill", accent: [Color(red: 0.88, green: 0.84, blue: 0.74), Color(red: 0.32, green: 0.28, blue: 0.18)], tag: "VAULT"),
        .init(id: .chat, title: "AI Chat Assistant", subtitle: "Ask the AI architect anything, anytime", icon: "bubble.left.and.text.bubble.right.fill", accent: [Color(red: 0.74, green: 0.78, blue: 1.0), Color(red: 0.22, green: 0.18, blue: 0.55)], tag: "AI")
    ]
}

struct HomeView: View {
    @Bindable var appState: AppState
    @State private var appearedIndices: Set<Int> = []
    @State private var pulse: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LuxuryBackground()
                AnimatedAuroraLayer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        DashboardHeader(name: appState.userName, projectCount: appState.projects.count, pulse: pulse)

                        SectionLabel(title: "AI Studio", caption: "Tap a module to begin")

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                            ForEach(Array(DashboardFeature.all.enumerated()), id: \.element.id) { index, feature in
                                NavigationLink(value: feature.id) {
                                    DashboardCard(feature: feature, index: index)
                                }
                                .buttonStyle(.plain)
                                .opacity(appearedIndices.contains(index) ? 1 : 0)
                                .offset(y: appearedIndices.contains(index) ? 0 : 24)
                                .animation(.spring(response: 0.55, dampingFraction: 0.82).delay(Double(index) * 0.07), value: appearedIndices)
                            }
                        }

                        if !appState.projects.isEmpty {
                            SectionLabel(title: "Recent concepts", caption: "Continue where you left off")
                            ForEach(appState.projects.prefix(2)) { project in
                                ProjectCard(project: project)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .generate: CreateDesignView(appState: appState)
                case .voice: SilentDesignerView(appState: appState)
                case .land: EmptyLandVisionView(appState: appState)
                case .cultural: CulturalArchitectureView()
                case .redesign: ReDesignView(appState: appState)
                case .saved: GalleryView(projects: appState.projects)
                case .chat: ChatView(appState: appState)
                }
            }
            .onAppear {
                pulse = true
                for i in DashboardFeature.all.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                        appearedIndices.insert(i)
                    }
                }
            }
        }
    }
}

struct DashboardHeader: View {
    let name: String
    let projectCount: Int
    let pulse: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(0.18))
                        .frame(width: 10, height: 10)
                        .scaleEffect(pulse ? 2.6 : 1)
                        .opacity(pulse ? 0 : 1)
                        .animation(.easeOut(duration: 1.6).repeatForever(autoreverses: false), value: pulse)
                    Circle()
                        .fill(Theme.gold)
                        .frame(width: 7, height: 7)
                }
                Text("ARCHAI · ONLINE")
                    .font(.caption2.weight(.bold))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                Spacer()
                Text("v1.0")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome,")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.55))
                Text(name)
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                Text("Design futuristic spaces with AI as your co-architect.")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.62))
                    .lineSpacing(2)
            }

            HStack(spacing: 10) {
                StatPill(icon: "square.stack.3d.up.fill", value: "\(projectCount)", label: "Projects")
                StatPill(icon: "sparkles", value: "6", label: "AI Modules")
                StatPill(icon: "bolt.fill", value: "Live", label: "Engine")
            }
        }
    }
}

struct StatPill: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.gold)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.05), in: .rect(cornerRadius: 14))
        .overlay(.white.opacity(0.08), in: .rect(cornerRadius: 14).stroke(lineWidth: 1))
    }
}

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

struct AnimatedAuroraLayer: View {
    @State private var animate: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.gold.opacity(0.22))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: animate ? 140 : 80, y: animate ? -300 : -260)
            Circle()
                .fill(Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.16))
                .frame(width: 280, height: 280)
                .blur(radius: 100)
                .offset(x: animate ? -160 : -100, y: animate ? 120 : 200)
            Circle()
                .fill(Color(red: 1.0, green: 0.4, blue: 0.6).opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 90)
                .offset(x: animate ? 100 : 40, y: animate ? 360 : 320)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

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
                    TogglePill(title: "Men’s Majlis", isOn: $menMajlis)
                    TogglePill(title: "Women’s Majlis", isOn: $womenMajlis)
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
            roomLayout: "Use a grand arrival axis, then branch into men’s majlis near the guest entrance, women’s majlis close to dining, family living facing garden views, and bedrooms around a calm upper lounge.",
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

struct ChatView: View {
    @Bindable var appState: AppState
    @State private var question: String = ""
    @State private var messages: [ChatBubbleMessage] = [
        ChatBubbleMessage(role: .ai, text: "Hi, I'm your AI architect. Ask me about layouts, privacy, facades, lighting, or material choices.")
    ]
    @State private var isThinking: Bool = false

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack(spacing: 14) {
                HeaderBlock(title: "AI Chat Assistant", subtitle: "Fast guidance for planning decisions and design tradeoffs.")
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                            if isThinking {
                                HStack(spacing: 8) {
                                    ProgressView().tint(Theme.gold)
                                    Text("ArchAI is thinking...")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 14)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let last = messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                HStack(spacing: 10) {
                    TextField("Ask a question", text: $question)
                        .textFieldStyle(.plain)
                        .padding(14)
                        .background(.white.opacity(0.08), in: .rect(cornerRadius: 16))
                        .foregroundStyle(.white)
                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.headline)
                            .frame(width: 48, height: 48)
                    }
                    .buttonStyle(GoldIconButtonStyle())
                    .disabled(question.trimmingCharacters(in: .whitespaces).isEmpty || isThinking)
                }
                .padding(20)
            }
        }
        .navigationTitle("AI Chat")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func send() {
        let text = question.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        messages.append(ChatBubbleMessage(role: .user, text: text))
        question = ""
        isThinking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isThinking = false
            messages.append(ChatBubbleMessage(role: .ai, text: "Separate guest circulation with a direct majlis route from the entry court, then use a screened transition before family spaces. Keep service paths behind dining and kitchen for clean operation."))
        }
    }
}

struct ChatBubbleMessage: Identifiable, Hashable {
    enum Role { case user, ai }
    let id: UUID = UUID()
    let role: Role
    let text: String
}

struct ChatBubble: View {
    let message: ChatBubbleMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 40) }
            Text(message.text)
                .foregroundStyle(message.role == .user ? .black : .white.opacity(0.88))
                .padding(14)
                .background(
                    message.role == .user
                    ? AnyShapeStyle(Theme.goldGradient)
                    : AnyShapeStyle(Color.white.opacity(0.07)),
                    in: .rect(cornerRadius: 18)
                )
            if message.role == .ai { Spacer(minLength: 40) }
        }
    }
}

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

struct ProfileView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack(alignment: .leading, spacing: 18) {
                HeaderBlock(title: "Profile", subtitle: "Account, Supabase sync, and studio preferences.")
                VStack(alignment: .leading, spacing: 14) {
                    Label(appState.userName, systemImage: "person.crop.circle.fill")
                    Label("Supabase auth ready", systemImage: "checkmark.seal.fill")
                    Label("OpenAI endpoints scaffolded", systemImage: "brain.head.profile")
                    Label("Expo Go requested; native Rork preview currently uses Swift", systemImage: "iphone")
                }
                .foregroundStyle(.white.opacity(0.86))
                .padding(18)
                .background(.white.opacity(0.07), in: .rect(cornerRadius: 24))
                Button("Sign out") {
                    appState.isAuthenticated = false
                }
                .buttonStyle(GoldButtonStyle())
                Spacer()
            }
            .padding(20)
        }
    }
}

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

struct TogglePill: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .tint(Theme.gold)
            .foregroundStyle(.white)
            .padding(14)
            .background(.white.opacity(0.07), in: .rect(cornerRadius: 18))
    }
}

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

struct LuxurySecureField: View {
    let title: String
    @Binding var text: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Theme.gold)
                .frame(width: 22)
            SecureField(title, text: $text)
                .foregroundStyle(.white)
        }
        .padding(15)
        .background(.white.opacity(0.07), in: .rect(cornerRadius: 18))
        .overlay(.white.opacity(0.08), in: .rect(cornerRadius: 18).stroke(lineWidth: 1))
    }
}

struct GoldButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.black)
            .padding(.vertical, 16)
            .background(Theme.goldGradient, in: .rect(cornerRadius: 18))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

struct GoldIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.black)
            .background(Theme.goldGradient, in: .circle)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
    }
}

struct LuxuryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 0.05, green: 0.045, blue: 0.035), Color(red: 0.11, green: 0.085, blue: 0.045)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(Theme.gold.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: 130, y: -260)
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 220, height: 220)
                .blur(radius: 70)
                .offset(x: -130, y: 230)
        }
        .ignoresSafeArea()
    }
}

enum Theme {
    static let gold = Color(red: 0.86, green: 0.68, blue: 0.34)
    static let goldGradient = LinearGradient(colors: [Color(red: 0.98, green: 0.86, blue: 0.52), Color(red: 0.65, green: 0.45, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cardGradient = LinearGradient(colors: [.white.opacity(0.10), .white.opacity(0.045)], startPoint: .topLeading, endPoint: .bottomTrailing)
}

#Preview {
    ContentView()
}
