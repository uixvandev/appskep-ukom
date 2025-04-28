//
//  LoginResponseModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation

// MARK: - Root Response
struct AuthResponseModel: Codable {
    let message: Message
    let data: AuthData?
    let error: String?
}

// MARK: - Message
struct Message: Codable {
    let success: String
}

// MARK: - Data
struct AuthData: Codable {
    let accessToken: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}
