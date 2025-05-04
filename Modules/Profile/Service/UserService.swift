//
//  UserService.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

class UserService {
    func fetchUserProfile() async throws -> User {
        let response: UserProfileResponse = try await APIService.shared.request(
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
        
        // Gunakan method requestRaw untuk menghindari masalah decoding
        let response = try await APIService.shared.requestRaw(
            service: .auth,
            endpoint: .updateUser,
            method: "PUT",
            body: body,
            authenticated: true
        )
        
        // Validasi respons mentah (opsional)
        guard let message = response["message"] as? [String: Any],
              let success = message["success"] as? String else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Respons update profile tidak valid"])
        }
        
        print("✅ Update profile berhasil: \(success)")
        
        // Tidak mengembalikan model User karena kita akan melakukan fetch terpisah
    }
}
