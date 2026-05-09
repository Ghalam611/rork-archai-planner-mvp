//
//  APIConfig.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import Foundation

/// Configuration for API keys and endpoints
/// API keys should be set in environment variables or .env file
struct APIConfig {
    
    // MARK: - Environment Keys
    private static let openAIKeyKey = "OPENAI_API_KEY"
    private static let supabaseURLKey = "SUPABASE_URL"
    private static let supabaseAnonKeyKey = "SUPABASE_ANON_KEY"
    private static let rorkFunctionsURLKey = "RORK_FUNCTIONS_URL"
    
    // MARK: - API Keys (loaded from environment)
    static var openAIKey: String {
        return getValue(for: openAIKeyKey) ?? ""
    }
    
    static var supabaseURL: String {
        return getValue(for: supabaseURLKey) ?? ""
    }
    
    static var supabaseAnonKey: String {
        return getValue(for: supabaseAnonKeyKey) ?? ""
    }
    
    static var rorkFunctionsURL: String {
        return getValue(for: rorkFunctionsURLKey) ?? ""
    }
    
    // MARK: - Configuration State
    static var hasValidOpenAIKey: Bool {
        !openAIKey.isEmpty && openAIKey != "your-openai-key-here"
    }
    
    static var hasValidSupabaseConfig: Bool {
        !supabaseURL.isEmpty && supabaseURL != "your-supabase-url-here" &&
        !supabaseAnonKey.isEmpty && supabaseAnonKey != "your-supabase-anon-key-here"
    }
    
    static var hasValidBackendURL: Bool {
        !rorkFunctionsURL.isEmpty && rorkFunctionsURL != "your-rork-functions-url-here"
    }
    
    static var isDemoMode: Bool {
        !hasValidOpenAIKey || !hasValidSupabaseConfig || !hasValidBackendURL
    }
    
    // MARK: - Environment Variable Loading
    private static func getValue(for key: String) -> String? {
        // First try environment variables
        if let value = ProcessInfo.processInfo.environment[key] {
            return value
        }
        
        // Then try .env file (for development)
        if let path = Bundle.main.path(forResource: ".env", ofType: nil),
           let data = FileManager.default.contents(atPath: path),
           let content = String(data: data, encoding: .utf8) {
            
            for line in content.components(separatedBy: .newlines) {
                let components = line.components(separatedBy: "=")
                if components.count == 2 && components[0].trimmingCharacters(in: .whitespaces) == key {
                    return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        return nil
    }
    
    // MARK: - API Endpoints
    static var openAIBaseURL: String {
        return "https://api.openai.com/v1"
    }
    
    static var supabaseBaseURL: String {
        return supabaseURL
    }
    
    static var functionsBaseURL: String {
        return rorkFunctionsURL
    }
    
    // MARK: - Model Configuration
    static var chatModel: String {
        return "gpt-4"
    }
    
    static var imageModel: String {
        return "dall-e-3"
    }
    
    static var analysisModel: String {
        return "gpt-4-vision-preview"
    }
    
    // MARK: - Request Configuration
    static var requestTimeout: TimeInterval {
        return 60.0
    }
    
    static var maxRetries: Int {
        return 3
    }
    
    static var retryDelay: TimeInterval {
        return 2.0
    }
}

// MARK: - Configuration Validation
extension APIConfig {
    static func validateConfiguration() -> ConfigurationStatus {
        var issues: [String] = []
        
        if !hasValidOpenAIKey {
            issues.append("OpenAI API key is missing or invalid")
        }
        
        if !hasValidSupabaseConfig {
            issues.append("Supabase configuration is missing or invalid")
        }
        
        if !hasValidBackendURL {
            issues.append("RORK Functions URL is missing or invalid")
        }
        
        return ConfigurationStatus(
            isValid: issues.isEmpty,
            isDemoMode: isDemoMode,
            issues: issues
        )
    }
}

// MARK: - Configuration Status
struct ConfigurationStatus {
    let isValid: Bool
    let isDemoMode: Bool
    let issues: [String]
    
    var statusMessage: String {
        if isValid {
            return "All API configurations are valid"
        } else if isDemoMode {
            return "Running in Demo Mode - Some features may be limited"
        } else {
            return "Configuration issues found"
        }
    }
    
    var statusColor: String {
        if isValid {
            return "green"
        } else if isDemoMode {
            return "orange"
        } else {
            return "red"
        }
    }
}
