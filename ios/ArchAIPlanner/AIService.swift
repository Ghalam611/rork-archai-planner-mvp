import Foundation

/// Central networking layer for ArchAI Planner with real API integration and fallback to demo mode
class AIService: ObservableObject {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    @Published var isLoading = false
    @Published var lastError: AIServiceError?
    @Published var configurationStatus: ConfigurationStatus
    
    // MARK: - Initialization
    init() {
        self.session = URLSession.shared
        self.decoder = JSONDecoder()
        self.configurationStatus = APIConfig.validateConfiguration()
    }
    
    // MARK: - Public API Methods
    
    /// Generate architecture design using real AI or fallback to mock
    func generateArchitecture(prompt: ArchitecturePrompt) async throws -> AIResult {
        isLoading = true
        lastError = nil
        
        do {
            let result: AIResult
            
            if APIConfig.isDemoMode {
                result = try await generateMockArchitecture(prompt: prompt)
            } else {
                result = try await generateRealArchitecture(prompt: prompt)
            }
            
            isLoading = false
            return result
        } catch {
            isLoading = false
            lastError = AIServiceError.from(error)
            throw lastError ?? AIServiceError.unknownError
        }
    }
    
    /// Analyze architecture from text description
    func analyzeArchitectureText(text: String) async throws -> ArchitectureAnalysis {
        isLoading = true
        lastError = nil
        
        do {
            let result: ArchitectureAnalysis
            
            if APIConfig.isDemoMode {
                result = try await generateMockAnalysis(text: text)
            } else {
                result = try await generateRealAnalysis(text: text)
            }
            
            isLoading = false
            return result
        } catch {
            isLoading = false
            lastError = AIServiceError.from(error)
            throw lastError ?? AIServiceError.unknownError
        }
    }
    
    /// Chat with AI architecture assistant
    func chatWithAI(messages: [ChatMessage]) async throws -> ChatMessage {
        isLoading = true
        lastError = nil
        
        do {
            let result: ChatMessage
            
            if APIConfig.isDemoMode {
                result = try await generateMockChatResponse(messages: messages)
            } else {
                result = try await generateRealChatResponse(messages: messages)
            }
            
            isLoading = false
            return result
        } catch {
            isLoading = false
            lastError = AIServiceError.from(error)
            throw lastError ?? AIServiceError.unknownError
        }
    }
    
    // MARK: - Real API Implementations
    
    private func generateRealArchitecture(prompt: ArchitecturePrompt) async throws -> AIResult {
        guard let url = URL(string: "\(APIConfig.functionsBaseURL)/generate-architecture") else {
            throw AIServiceError.invalidEndpoint
        }
        
        let request = try createAuthenticatedRequest(url: url, method: "POST", body: prompt)
        let (data, _) = try await performRequestWithRetry(request: request)
        return try decoder.decode(AIResult.self, from: data)
    }
    
    private func generateRealAnalysis(text: String) async throws -> ArchitectureAnalysis {
        guard let url = URL(string: "\(APIConfig.openAIBaseURL)/chat/completions") else {
            throw AIServiceError.invalidEndpoint
        }
        
        let requestBody = OpenAIChatRequest(
            model: APIConfig.chatModel,
            messages: [
                OpenAIMessage(role: "system", content: "You are an expert architecture analyst. Analyze the following architecture description and provide detailed insights."),
                OpenAIMessage(role: "user", content: text)
            ],
            maxTokens: 1000,
            temperature: 0.7
        )
        
        let request = try createOpenAIRequest(url: url, body: requestBody)
        let (data, _) = try await performRequestWithRetry(request: request)
        let response = try decoder.decode(OpenAIChatResponse.self, from: data)
        
        return try parseArchitectureAnalysis(from: response.choices.first?.message.content ?? "")
    }
    
    private func generateRealChatResponse(messages: [ChatMessage]) async throws -> ChatMessage {
        guard let url = URL(string: "\(APIConfig.functionsBaseURL)/architecture-chat") else {
            throw AIServiceError.invalidEndpoint
        }
        
        let requestBody = ChatRequest(messages: messages)
        let request = try createAuthenticatedRequest(url: url, method: "POST", body: requestBody)
        let (data, _) = try await performRequestWithRetry(request: request)
        return try decoder.decode(ChatMessage.self, from: data)
    }
    
    // MARK: - Mock Implementations
    
    private func generateMockArchitecture(prompt: ArchitecturePrompt) async throws -> AIResult {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        return AIResult(
            projectName: prompt.projectName,
            clientName: prompt.clientName,
            location: prompt.location,
            plotSize: prompt.plotSize,
            totalArea: prompt.totalArea,
            floors: prompt.floors,
            style: prompt.style,
            summary: generateMockSummary(prompt: prompt),
            rooms: generateMockRooms(prompt: prompt),
            materials: MaterialSuggestion.sampleMaterials,
            budget: generateMockBudget(prompt: prompt),
            images: GeneratedImage.sampleImages
        )
    }
    
    private func generateMockAnalysis(text: String) async throws -> ArchitectureAnalysis {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return ArchitectureAnalysis(
            style: .modernSaudi,
            keyFeatures: ["Open floor plan", "Natural lighting", "Modern amenities"],
            materials: ["Concrete", "Glass", "Steel"],
            estimatedCost: 2500000,
            sustainabilityScore: 0.85,
            recommendations: ["Add solar panels", "Improve insulation", "Use local materials"]
        )
    }
    
    private func generateMockChatResponse(messages: [ChatMessage]) async throws -> ChatMessage {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let lastMessage = messages.last?.content ?? ""
        let response = generateMockResponse(for: lastMessage)
        
        return ChatMessage(
            id: UUID(),
            role: "assistant",
            content: response
        )
    }
    
    // MARK: - Helper Methods
    
    private func createAuthenticatedRequest<T: Encodable>(url: URL, method: String, body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication headers if needed
        if !APIConfig.supabaseAnonKey.isEmpty {
            request.setValue("Bearer \(APIConfig.supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = APIConfig.requestTimeout
        
        return request
    }
    
    private func createOpenAIRequest<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIConfig.openAIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = APIConfig.requestTimeout
        
        return request
    }
    
    private func performRequestWithRetry(request: URLRequest) async throws -> (Data, URLResponse) {
        var lastError: Error?
        
        for attempt in 1...APIConfig.maxRetries {
            do {
                let (data, response) = try await session.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        return (data, response)
                    } else {
                        throw AIServiceError.httpError(httpResponse.statusCode)
                    }
                }
                
                return (data, response)
            } catch {
                lastError = error
                
                if attempt < APIConfig.maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(APIConfig.retryDelay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? AIServiceError.requestFailed
    }
    
    // MARK: - Mock Data Generators
    
    private func generateMockSummary(prompt: ArchitecturePrompt) -> ArchitectureSummary {
        ArchitectureSummary(
            concept: "AI-generated \(prompt.style.rawValue.lowercased()) design tailored for your specific requirements in \(prompt.location).",
            keyFeatures: [
                "Optimized layout for \(prompt.style.rawValue) aesthetics",
                "Climate-adapted design for \(prompt.location)",
                "Modern amenities with traditional elements",
                "Sustainable building practices"
            ],
            sustainabilityScore: Double.random(in: 0.75...0.95),
            energyEfficiency: "Grade A - Advanced energy-efficient systems",
            climateAdaptation: "Designed for local climate conditions",
            culturalElements: [
                "\(prompt.style.rawValue) architectural elements",
                "Local material recommendations",
                "Cultural design considerations"
            ]
        )
    }
    
    private func generateMockRooms(prompt: ArchitecturePrompt) -> [Room] {
        [
            Room(name: "Master Bedroom", area: 45, floor: 1, purpose: .bedroom, features: ["Walk-in closet", "En-suite bathroom"], ventilation: "Natural ventilation", lighting: "LED lighting"),
            Room(name: "Living Room", area: 60, floor: 1, purpose: .living, features: ["Entertainment center", "Fireplace"], ventilation: "Cross ventilation", lighting: "Natural light + LED"),
            Room(name: "Kitchen", area: 35, floor: 1, purpose: .kitchen, features: ["Modern appliances", "Island"], ventilation: "Exhaust system", lighting: "Task lighting"),
            Room(name: "Majlis", area: 50, floor: 1, purpose: .majlis, features: ["Traditional seating", "Decorative elements"], ventilation: "Natural ventilation", lighting: "Warm LED")
        ]
    }
    
    private func generateMockBudget(prompt: ArchitecturePrompt) -> BudgetEstimate {
        let baseAmount = prompt.totalArea * 3000 // SAR 3000 per m²
        
        return BudgetEstimate(
            total: baseAmount,
            breakdown: [
                BudgetCategory(name: "Foundation & Structure", amount: baseAmount * 0.30, percentage: 30.0),
                BudgetCategory(name: "Exterior & Roofing", amount: baseAmount * 0.25, percentage: 25.0),
                BudgetCategory(name: "Interior Finishing", amount: baseAmount * 0.20, percentage: 20.0),
                BudgetCategory(name: "Kitchen & Bathrooms", amount: baseAmount * 0.15, percentage: 15.0),
                BudgetCategory(name: "Landscaping", amount: baseAmount * 0.05, percentage: 5.0),
                BudgetCategory(name: "Smart Home & Systems", amount: baseAmount * 0.05, percentage: 5.0)
            ],
            currency: "SAR",
            contingency: baseAmount * 0.10,
            timeline: "8-12 months"
        )
    }
    
    private func generateMockResponse(for message: String) -> String {
        if message.lowercased().contains("modern") {
            return "Modern Saudi architecture combines contemporary design elements with traditional Islamic influences. It features clean lines, open spaces, and incorporates modern materials while maintaining cultural authenticity."
        } else if message.lowercased().contains("traditional") {
            return "Traditional Saudi architecture, particularly Najdi style, emphasizes thick walls for insulation, small windows for climate control, and central courtyards for ventilation. It uses local materials like mud brick and limestone."
        } else {
            return "I'm here to help you with your architecture needs. Whether you're interested in modern designs, traditional styles, or specific cultural elements, I can provide detailed insights and recommendations for your project."
        }
    }
    
    private func parseArchitectureAnalysis(from content: String) throws -> ArchitectureAnalysis {
        // In a real implementation, this would parse AI response
        return ArchitectureAnalysis(
            style: .modernSaudi,
            keyFeatures: ["Open floor plan", "Natural lighting", "Modern amenities"],
            materials: ["Concrete", "Glass", "Steel"],
            estimatedCost: 2500000,
            sustainabilityScore: 0.85,
            recommendations: ["Add solar panels", "Improve insulation", "Use local materials"]
        )
    }
}

// MARK: - Error Types
enum AIServiceError: LocalizedError {
    case invalidEndpoint
    case missingAPIKey
    case requestFailed
    case httpError(Int)
    case decodingError
    case imageGenerationFailed
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "The API endpoint is not configured correctly."
        case .missingAPIKey:
            return "API key is missing. Please configure your API keys."
        case .requestFailed:
            return "Network request failed. Please check your connection."
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError:
            return "Failed to decode API response."
        case .imageGenerationFailed:
            return "Failed to generate image."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
    
    static func from(_ error: Error) -> AIServiceError {
        if let aiError = error as? AIServiceError {
            return aiError
        } else if error is DecodingError {
            return .decodingError
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .requestFailed
            default:
                return .unknownError
            }
        } else {
            return .unknownError
        }
    }
}

// MARK: - Data Models for API Requests
struct ArchitecturePrompt: Codable {
    let projectName: String
    let clientName: String
    let location: String
    let plotSize: Double
    let totalArea: Double
    let floors: Int
    let style: ArchitectureStyle
    let requirements: String
}

struct ChatRequest: Codable {
    let messages: [ChatMessage]
}

// MARK: - OpenAI API Models
struct OpenAIChatRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let maxTokens: Int?
    let temperature: Double?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIChatResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}

// MARK: - Analysis Models
struct ArchitectureAnalysis: Codable {
    let style: ArchitectureStyle
    let keyFeatures: [String]
    let materials: [String]
    let estimatedCost: Double
    let sustainabilityScore: Double
    let recommendations: [String]
}
