//
//  GetUserResponse.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation


struct UserProfileResponseModel: Codable {
    let message: Message
    let data: UserProfileData
    let error: String?
    
    struct Message: Codable {
        let success: String
    }
    
    struct UserProfileData: Codable {
        let user: User
    }
}
