//
//  SupabaseService.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import Foundation
import SwiftUI

/// Supabase integration for real-time project storage and synchronization
class SupabaseService: ObservableObject {
    
    // MARK: - Properties
    private let baseURL: String
    private let apiKey: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    @Published var isConnected = false
    @Published var lastError: SupabaseError?
    @Published var isLoading = false
    
    // MARK: - Initialization
    init() {
        self.baseURL = APIConfig.supabaseURL
        self.apiKey = APIConfig.supabaseAnonKey
        self.session = URLSession.shared
        self.decoder = JSONDecoder()
        
        // Set up date decoding strategy
        decoder.dateDecodingStrategy = .iso8601
        
        // Check connection
        Task {
            await checkConnection()
        }
    }
    
    // MARK: - Connection Management
    
    private func checkConnection() async {
        guard !APIConfig.isDemoMode else {
            isConnected = false
            return
        }
        
        do {
            let _ = try await performRequest(
                endpoint: "rest/v1/",
                method: "GET",
                body: nil as String?
            )
            isConnected = true
        } catch {
            isConnected = false
            lastError = SupabaseError.from(error)
        }
    }
    
    // MARK: - Project Management
    
    /// Save project to Supabase
    func saveProject(_ project: AIResult) async throws -> AIResult {
        guard !APIConfig.isDemoMode else {
            throw SupabaseError.demoMode
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let projectData = try ProjectData.from(project)
            let savedProject = try await performRequest(
                endpoint: "rest/v1/projects",
                method: "POST",
                body: projectData
            )
            
            isConnected = true
            HapticFeedback.shared.light()
            return try decoder.decode(AIResult.self, from: savedProject)
        } catch {
            lastError = SupabaseError.from(error)
            throw lastError ?? SupabaseError.unknownError
        }
    }
    
    /// Load user's projects from Supabase
    func loadProjects() async throws -> [AIResult] {
        guard !APIConfig.isDemoMode else {
            throw SupabaseError.demoMode
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let projectsData = try await performRequest(
                endpoint: "rest/v1/projects?order=created_at.desc",
                method: "GET",
                body: nil as String?
            )
            
            isConnected = true
            let projectDataArray = try decoder.decode([ProjectData].self, from: projectsData)
            return try projectDataArray.map { try $0.toAIResult() }
        } catch {
            lastError = SupabaseError.from(error)
            throw lastError ?? SupabaseError.unknownError
        }
    }
    
    /// Delete project from Supabase
    func deleteProject(_ projectId: UUID) async throws {
        guard !APIConfig.isDemoMode else {
            throw SupabaseError.demoMode
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _ = try await performRequest(
                endpoint: "rest/v1/projects?id=eq.\(projectId.uuidString)",
                method: "DELETE",
                body: nil as String?
            )
            
            isConnected = true
            HapticFeedback.shared.medium()
        } catch {
            lastError = SupabaseError.from(error)
            throw lastError ?? SupabaseError.unknownError
        }
    }
    
    // MARK: - Helper Methods
    
    private func performRequest<T: Encodable, U: Decodable>(
        endpoint: String,
        method: String,
        body: T?
    ) async throws -> Data {
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw SupabaseError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        request.timeoutInterval = APIConfig.requestTimeout
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if (200...299).contains(httpResponse.statusCode) {
                return data
            } else {
                throw SupabaseError.httpError(httpResponse.statusCode)
            }
        }
        
        return data
    }
    
    private func performRequest<T: Encodable>(
        endpoint: String,
        method: String,
        body: T?
    ) async throws -> Data {
        return try await performRequest(endpoint: endpoint, method: method, body: body)
    }
}

// MARK: - Project Data Model for Supabase
struct ProjectData: Codable {
    let id: UUID
    let projectName: String
    let clientName: String
    let location: String
    let plotSize: Double
    let totalArea: Double
    let floors: Int
    let style: String
    let summary: ArchitectureSummary
    let rooms: [Room]
    let materials: [MaterialSuggestion]
    let budget: BudgetEstimate
    let images: [GeneratedImage]
    let timestamp: Date
    let aiConfidence: Double
    let processingTime: TimeInterval
    let userId: String
    
    init(from project: AIResult) {
        self.id = project.id
        self.projectName = project.projectName
        self.clientName = project.clientName
        self.location = project.location
        self.plotSize = project.plotSize
        self.totalArea = project.totalArea
        self.floors = project.floors
        self.style = project.style.rawValue
        self.summary = project.summary
        self.rooms = project.rooms
        self.materials = project.materials
        self.budget = project.budget
        self.images = project.images
        self.timestamp = project.timestamp
        self.aiConfidence = project.aiConfidence
        self.processingTime = project.processingTime
        self.userId = "current-user" // In real app, this would be actual user ID
    }
    
    func toAIResult() throws -> AIResult {
        guard let style = ArchitectureStyle(rawValue: self.style) else {
            throw SupabaseError.decodingError
        }
        
        return AIResult(
            projectName: projectName,
            clientName: clientName,
            location: location,
            plotSize: plotSize,
            totalArea: totalArea,
            floors: floors,
            style: style,
            summary: summary,
            rooms: rooms,
            materials: materials,
            budget: budget,
            images: images,
            aiConfidence: aiConfidence,
            processingTime: processingTime
        )
    }
}

// MARK: - Error Types
enum SupabaseError: LocalizedError {
    case invalidURL
    case demoMode
    case connectionFailed
    case uploadFailed
    case decodingError
    case httpError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Supabase URL configuration."
        case .demoMode:
            return "Cannot connect to Supabase in demo mode."
        case .connectionFailed:
            return "Failed to connect to Supabase."
        case .uploadFailed:
            return "Failed to upload file to Supabase."
        case .decodingError:
            return "Failed to decode Supabase response."
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
    
    static func from(_ error: Error) -> SupabaseError {
        if let supabaseError = error as? SupabaseError {
            return supabaseError
        } else if error is DecodingError {
            return .decodingError
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .connectionFailed
            default:
                return .unknownError
            }
        } else {
            return .unknownError
        }
    }
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

enum SupabaseServiceError: LocalizedError {
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
