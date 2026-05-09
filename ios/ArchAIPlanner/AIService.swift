import Foundation

/// Central networking layer for ArchAI Planner.
/// In production, call your own secure backend endpoints here so the OpenAI key never ships in the app.
struct AIService {
    private let functionsBaseURL: URL?

    init(functionsBaseURL: String = Config.EXPO_PUBLIC_RORK_FUNCTIONS_URL) {
        self.functionsBaseURL = URL(string: functionsBaseURL)
    }

    /// Calls the backend endpoint that wraps OpenAI and returns architectural planning suggestions.
    func generateDesign(prompt: DesignPrompt) async throws -> DesignResult {
        guard let url = functionsBaseURL?.appending(path: "generate-architecture") else {
            throw AIServiceError.missingEndpoint
        }

        let request = try makePostRequest(url: url, body: prompt)
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try JSONDecoder().decode(DesignResult.self, from: data)
    }

    /// Calls the backend endpoint that wraps OpenAI chat for architecture Q&A.
    func chat(messages: [ChatMessage]) async throws -> ChatMessage {
        guard let url = functionsBaseURL?.appending(path: "architecture-chat") else {
            throw AIServiceError.missingEndpoint
        }

        let request = try makePostRequest(url: url, body: ["messages": messages])
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try JSONDecoder().decode(ChatMessage.self, from: data)
    }

    private func makePostRequest<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }

    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AIServiceError.requestFailed
        }
    }
}

nonisolated struct DesignPrompt: Codable {
    let landSize: String
    let floors: String
    let bedrooms: String
    let hasMenMajlis: Bool
    let hasWomenMajlis: Bool
    let hasGarden: Bool
    let hasPool: Bool
    let architecturalStyle: String
    let specialRequirements: String
}

nonisolated struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let role: String
    let content: String
}

nonisolated enum AIServiceError: LocalizedError {
    case missingEndpoint
    case requestFailed

    var errorDescription: String? {
        switch self {
        case .missingEndpoint:
            return "The AI endpoint is not configured yet."
        case .requestFailed:
            return "ArchAI could not generate a response right now."
        }
    }
}
