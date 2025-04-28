//
//  APIService.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func request<T: Codable>(
        service: APIEnvironment,
        endpoint: APIEndpoint,
        method: String = "GET",
        body: [String: Any]? = nil,
        authenticated: Bool = false
    ) async throws -> T {
        let url = service.baseURL.appendingPathComponent(endpoint.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if authenticated {
            if let token = TokenManager.getToken() {
                print("🔑 Using token for authenticated request: \(token.prefix(15))...")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("⚠️ Authenticated request but no token found!")
            }
        }
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        // Debug print request details
        print("🔄 Request: \(method) \(url.absoluteString)")
        if let body = body {
            print("📦 Request body: \(body)")
        }
        print("📋 Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status Code: \(httpResponse.statusCode)")
                
                // Print response body for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
                    print("❌ Error Response Body: \(responseBody)")
                    
                    // Attempt to decode error response in a standard format
                    if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                       let errorMessage = errorResponse["message"] {
                        throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    }
                    
                    throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: HTTP \(httpResponse.statusCode)"])
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch {
                print("❌ Decoding error: \(error)")
                
                // Detail debugging info for decoding errors
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("⚠️ Key '\(key.stringValue)' not found: \(context.debugDescription)")
                        print("⚠️ Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                    case .valueNotFound(let type, let context):
                        print("⚠️ Value for type \(type) not found: \(context.debugDescription)")
                        print("⚠️ Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                    case .typeMismatch(let type, let context):
                        print("⚠️ Type mismatch for type \(type): \(context.debugDescription)")
                        print("⚠️ Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                    case .dataCorrupted(let context):
                        print("⚠️ Data corrupted: \(context.debugDescription)")
                        print("⚠️ Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                    @unknown default:
                        print("⚠️ Unknown decoding error")
                    }
                }
                
                print("❌ Failed to decode: \(T.self)")
                
                // Try simplified decoding as a fallback (for debugging only)
                do {
                    let anyJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("🔎 Raw JSON structure: \(anyJSON)")
                } catch {
                    print("⚠️ Couldn't even parse as generic JSON: \(error)")
                }
                
                throw error
            }
        } catch {
            // Network or other errors
            print("📶 Network or request error: \(error.localizedDescription)")
            throw error
        }
    }
}

// Extension to simplify logging path information
extension CodingKey {
    var pathDescription: String {
        return stringValue
    }
}
