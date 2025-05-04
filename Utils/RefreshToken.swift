//
//  RefreshToken.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 04/05/25.
//

import Foundation

func refreshToken() async throws -> String {
    guard let currentToken = TokenManager.getToken() else {
        throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token available to refresh"])
    }
    
    // Buat URL untuk refresh token
    var urlComponents = URLComponents(url: APIEnvironment.auth.baseURL.appendingPathComponent("/oauth/refresh-token"), resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = [URLQueryItem(name: "token", value: currentToken)]
    
    guard let url = urlComponents?.url else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid refresh token URL"])
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print("🔄 Refreshing token: GET \(url.absoluteString)")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    if let httpResponse = response as? HTTPURLResponse {
        print("📡 Refresh Token Status: \(httpResponse.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Refresh Token Response: \(responseString)")
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Token refresh failed"])
        }
    }
    
    // Parse response untuk mendapatkan token baru
    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let dataDict = json["data"] as? [String: Any],
       let newToken = dataDict["token"] as? String {
        
        // Simpan token baru
        TokenManager.saveToken(newToken)
        print("✅ Token refreshed successfully")
        return newToken
    } else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse refresh token response"])
    }
}
