import Foundation

final class AuthService {
  func login(email: String, password: String) async throws -> User {
    let body: [String: Any] = [
      "email": email,
      "password": password
    ]
    
    do {
      let response: AuthResponseModel = try await APIService.shared.request(
        service: .auth,
        endpoint: .login,
        method: "POST",
        body: body
      )
      
      print("👤 Auth response data: \(String(describing: response.data))")
      
      guard let data = response.data else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing response data"])
      }
      
      guard !data.accessToken.isEmpty else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token"])
      }
      
      TokenManager.saveToken(data.accessToken)
      return data.user
    } catch {
      // Tambahkan debug info
      print("📌 Login error details: \(error)")
      
      // Re-throw the error untuk ditangani oleh caller
      throw error
    }
  }
  
  func register(name: String, email: String, phone: String, password: String) async throws -> User {
    let body: [String: Any] = [
      "name": name,
      "email": email,
      "phone": phone,
      "password": password
    ]
    
    do {
      let response: AuthResponseModel = try await APIService.shared.request(
        service: .auth,
        endpoint: .register,
        method: "POST",
        body: body
      )
      
      print("Register response data: \(String(describing: response.data))")
      
      guard let data = response.data else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing Response Data"])
      }
      guard !data.accessToken.isEmpty else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token"])
      }
      
      TokenManager.saveToken(data.accessToken)
      return data.user
    } catch {
      print("Registration error details: \(error)")
      throw error
    }
  }
  
  func getUserProfile() async throws -> User {
    let response: UserProfileResponseModel = try await APIService.shared.request(
      service: .auth,
      endpoint: .getUser,
      method: "GET",
      authenticated: true
    )
    
    return response.data.user
  }
  
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
}
