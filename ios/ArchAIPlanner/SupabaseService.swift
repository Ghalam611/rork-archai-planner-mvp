import Foundation

/// Lightweight Supabase REST client scaffold for authentication and project persistence.
/// Replace placeholder environment values with your Supabase project URL and anon key.
struct SupabaseService {
    private let baseURL: URL?
    private let anonKey: String

    init(baseURL: String = "", anonKey: String = "") {
        self.baseURL = URL(string: baseURL)
        self.anonKey = anonKey
    }

    func saveProject(_ project: DesignProject, accessToken: String) async throws {
        guard let url = baseURL?.appending(path: "rest/v1/projects") else {
            throw SupabaseServiceError.missingConfiguration
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(project)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw SupabaseServiceError.requestFailed
        }
    }
}

nonisolated enum SupabaseServiceError: LocalizedError {
    case missingConfiguration
    case requestFailed

    var errorDescription: String? {
        switch self {
        case .missingConfiguration:
            return "Supabase is not configured yet."
        case .requestFailed:
            return "Could not sync this project to Supabase."
        }
    }
}
