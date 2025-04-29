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
    let response: UserProfileResponse = try await APIService.shared.request(
      service: .auth,
      endpoint: .getUser,
      method: "GET",
      authenticated: true
    )
    
    return response.data.user
  }
}
