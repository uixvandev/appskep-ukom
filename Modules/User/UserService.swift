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
}
