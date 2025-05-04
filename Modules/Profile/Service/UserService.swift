//
//  UserService.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

class UserService {
  func fetchUserProfile() async throws -> User {
    let response: UserProfileResponseModel = try await APIService.shared.request(
      service: .auth,
      endpoint: .getUser,
      method: "GET",
      authenticated: true
    )
    
    return response.data.user
  }
  
  func updateUserProfile(
      name: String,
      phone: String,
      email: String,
      sex: Int,
      education_Institution_Id: Int,
      address_province_id: Int,
      address_district_id: Int,
      subfield_id: Int,
      birth_date: String
  ) async throws {
      let body: [String: Any] = [
          "name": name,
          "email": email,
          "sex": sex,
          "phone": phone,
          "education_institution_id": education_Institution_Id,
          "address_province_id": address_province_id,
          "address_district_id": address_district_id,
          "subfield_id": subfield_id,
          "birthdate": birth_date
      ]
      
      print("📤 Update profile request: \(body)")
      
      do {
          // Coba update profile dengan token yang ada
          let response = try await APIService.shared.requestRaw(
              service: .auth,
              endpoint: .updateUser,
              method: "PUT",
              body: body,
              authenticated: true
          )
          
          // Validasi respons mentah
          guard let message = response["message"] as? [String: Any],
                let success = message["success"] as? String else {
              throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Respons update profile tidak valid"])
          }
          
          print("✅ Update profile berhasil: \(success)")
      } catch let error as NSError where error.code == 401 {
          // Jika error 401, coba refresh token dan coba update lagi
          print("⚠️ Token expired, attempting to refresh...")
          
          do {
              // Lakukan refresh token
              let authService = AuthService()
              _ = try await authService.refreshToken()
              
              // Coba lagi dengan token baru
              print("🔄 Retrying update with new token...")
              let response = try await APIService.shared.requestRaw(
                  service: .auth,
                  endpoint: .updateUser,
                  method: "PUT",
                  body: body,
                  authenticated: true
              )
              
              // Validasi respons mentah
              guard let message = response["message"] as? [String: Any],
                    let success = message["success"] as? String else {
                  throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Respons update profile tidak valid"])
              }
              
              print("✅ Update profile berhasil setelah refresh token: \(success)")
          } catch {
              print("❌ Failed after token refresh: \(error.localizedDescription)")
              throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication failed even after token refresh. Please login again."])
          }
      } catch {
          // Error lainnya
          print("❌ Profile update error: \(error.localizedDescription)")
          throw error
      }
  }
  
  func requestRaw(
      service: APIEnvironment,
      endpoint: APIEndpoint,
      method: String = "GET",
      body: [String: Any]? = nil,
      authenticated: Bool = false,
      attemptingRefresh: Bool = false // Parameter untuk mencegah infinite loop
  ) async throws -> [String: Any] {
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
      print("🔄 Raw Request: \(method) \(url.absoluteString)")
      if let body = body {
          print("📦 Raw Request body: \(body)")
      }
      print("📋 Raw Headers: \(request.allHTTPHeaderFields ?? [:])")
      
      let (data, response) = try await URLSession.shared.data(for: request)
      
      if let httpResponse = response as? HTTPURLResponse {
          print("📡 Raw Status Code: \(httpResponse.statusCode)")
          
          // Print response body for debugging
          if let responseString = String(data: data, encoding: .utf8) {
              print("📥 Raw Response: \(responseString)")
          }
          
          if httpResponse.statusCode == 401 && authenticated && !attemptingRefresh {
              // Token mungkin expired, coba refresh dan request ulang
              print("⚠️ Token expired (401), attempting to refresh...")
              
              do {
                  let authService = AuthService()
                  _ = try await authService.refreshToken()
                  
                  // Coba lagi dengan token baru, set attemptingRefresh=true untuk mencegah infinite loop
                  print("🔄 Retrying request with new token...")
                  return try await requestRaw(
                      service: service,
                      endpoint: endpoint,
                      method: method,
                      body: body,
                      authenticated: authenticated,
                      attemptingRefresh: true
                  )
              } catch {
                  print("❌ Token refresh failed: \(error.localizedDescription)")
                  throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication failed after token refresh attempt. Please login again."])
              }
          } else if !(200...299).contains(httpResponse.statusCode) {
              let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
              print("❌ Raw Error Response Body: \(responseBody)")
              throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: HTTP \(httpResponse.statusCode)"])
          }
      }
      
      // Parse respons langsung sebagai dictionary
      do {
          guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
              throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response bukan JSON yang valid"])
          }
          
          return json
      } catch {
          print("❌ Raw JSON parsing error: \(error)")
          throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal parsing JSON: \(error.localizedDescription)"])
      }
  }
  
  
  func fetchSubfields(clientId: String = "https://dev-ukom-frontend.appskep.id") async throws -> [SubfieldItem] {
      var urlComponents = URLComponents(url: APIEnvironment.auth.baseURL.appendingPathComponent(APIEndpoint.getSubfield.path), resolvingAgainstBaseURL: true)
      
      // Tambahkan query parameter
      urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
      
      // Pastikan URL valid
      guard let url = urlComponents?.url else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL tidak valid"])
      }
      
      // Buat request dengan URL yang sudah termasuk query parameters
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      // Tambahkan token autentikasi
      if let token = TokenManager.getToken() {
        print("🔑 Using token for authenticated request: \(token.prefix(15))...")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      }
      
      print("🔄 Manual Request: GET \(url.absoluteString)")
      
      // Lakukan request secara manual
      let (data, response) = try await URLSession.shared.data(for: request)
      
      // Cek status code
      if let httpResponse = response as? HTTPURLResponse {
        print("📡 Status Code: \(httpResponse.statusCode)")
        
        if !(200...299).contains(httpResponse.statusCode) {
          if let responseString = String(data: data, encoding: .utf8) {
            print("❌ Error Response: \(responseString)")
          }
          throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: HTTP \(httpResponse.statusCode)"])
        }
      }
      
      // Parse response dengan JSONDecoder
      do {
        let decoder = JSONDecoder()
        let subfieldResponse = try decoder.decode(SubfieldResponse.self, from: data)
        print("✅ Berhasil mendecode \(subfieldResponse.data.subfields.count) subfields")
        return subfieldResponse.data.subfields
      } catch {
        print("❌ Decode error: \(error)")
        
        // Fallback ke parsing manual sebagai cadangan
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataDict = json["data"] as? [String: Any],
           let subfieldsArray = dataDict["subfields"] as? [[String: Any]] {
          
          var items: [SubfieldItem] = []
          
          for dict in subfieldsArray {
            if let id = dict["id"] as? Int,
               let text = dict["text"] as? String {
              
              let item = SubfieldItem(
                id: id,
                text: text,
                fieldId: dict["field_id"] as? Int,
                description: dict["description"] as? String,  // Sesuaikan dengan model yang diubah
                createdBy: dict["created_by"] as? Int,
                updatedBy: dict["updated_by"] as? Int,
                createdAt: dict["created_at"] as? Int,
                updatedAt: dict["updated_at"] as? Int
              )
              
              items.append(item)
            }
          }
          
          print("✅ Parsing manual berhasil: \(items.count) subfields")
          return items
        }
        
        throw error
      }
  }
}
