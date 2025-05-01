//
//  LoginResponseModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation

struct AuthResponseModel: Codable {
  let message: Message
  let data: AuthData?
  let error: String?
}

struct Message: Codable {
  let success: String
}

struct AuthData: Codable {
  let accessToken: String
  let user: User
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case user
  }
}
