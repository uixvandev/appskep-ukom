//
//  SubfieldResponse.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 04/05/25.
//

import Foundation

struct SubfieldResponse: Codable {
    let message: Message
    let data: SubfieldData
    let error: String?
    
    struct Message: Codable {
        let success: String
    }
    
    struct SubfieldData: Codable {
        let subfields: [SubfieldItem]
    }
}

struct SubfieldItem: Codable, Identifiable {
    let id: Int
    let text: String
    let fieldId: Int?
    let description: String?
    let createdBy: Int?
    let updatedBy: Int?
    let createdAt: Int?
    let updatedAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, text, description
        case fieldId = "field_id"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
