//
//  UserModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation

struct User: Codable, Identifiable {
  let id: Int
  let uuid: String
  let username: String
  let email: String
  let phone: String
  let name: String
  let nickname: String
  let birthplace: String
  let birthdate: String
  let sex: Int
  let educationLevel: Int
  let educationLevelText: String
  let workInstitutionName: String
  let workInstitutionId: Int
  let institutionId: Int
  let provinceId: Int
  let districtId: Int
  let subdistrictId: Int
  let villageId: Int
  let address: String
  let isOrganizer: Int
  let status: Int
  let confirmedAt: Int
  let twoFactorAuthentication: TwoFactorAuth?
  let reviewStatus: Int
  let subfieldId: Int
  let createdAt: Int
  let updatedAt: Int
  let subfield: Subfield
  let institution: Institution
  let workInstitution: WorkInstitution?
  let province: Province
  let district: District
  let subdistrict: Subdistrict?
  let village: Village?
  
  enum CodingKeys: String, CodingKey {
    case id, uuid, username, email, phone, name, nickname, birthplace, birthdate, sex, address, status, subfield, institution, province, district, subdistrict, village
    case educationLevel = "education_level"
    case educationLevelText = "education_level_text"
    case workInstitutionName = "work_institution_name"
    case workInstitutionId = "work_institution_id"
    case institutionId = "institution_id"
    case provinceId = "province_id"
    case districtId = "district_id"
    case subdistrictId = "subdistrict_id"
    case villageId = "village_id"
    case isOrganizer = "is_organizer"
    case confirmedAt = "confirmed_at"
    case twoFactorAuthentication = "two_factor_authentication"
    case reviewStatus = "review_status"
    case subfieldId = "subfield_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case workInstitution = "workInstitution"
  }
}

// Model khusus untuk menangani two_factor_authentication yang bisa berupa string, int, atau null
struct TwoFactorAuth: Codable {
  let value: Any
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let stringValue = try? container.decode(String.self) {
      value = stringValue
    } else if let intValue = try? container.decode(Int.self) {
      value = intValue
    } else if container.decodeNil() {
      value = NSNull()
    } else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode two_factor_authentication")
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    if let stringValue = value as? String {
      try container.encode(stringValue)
    } else if let intValue = value as? Int {
      try container.encode(intValue)
    } else {
      try container.encodeNil()
    }
  }
}


struct Subfield: Codable {
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

struct Institution: Codable {
  let id: Int
  let name: String
  let code: String
  let type: Int
  let mergedTo: Int
  let provinceId: String
  let districtId: String
  let subdistrictId: String
  let villageId: String
  let address: String
  let createdAt: Int
  let updatedAt: Int
  let province: Province
  let district: District
  
  enum CodingKeys: String, CodingKey {
    case id, name, code, type, address, province, district
    case mergedTo = "merged_to"
    case provinceId = "province_id"
    case districtId = "district_id"
    case subdistrictId = "subdistrict_id"
    case villageId = "village_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

struct WorkInstitution: Codable {
  let id: Int
  let name: String
  let code: String
  let type: Int
  let mergedTo: Int
  let provinceId: String
  let districtId: String
  let subdistrictId: String
  let villageId: String
  let address: String
  let createdAt: Int
  let updatedAt: Int
  let province: Province
  let district: District
  
  enum CodingKeys: String, CodingKey {
    case id, name, code, type, address, province, district
    case mergedTo = "merged_to"
    case provinceId = "province_id"
    case districtId = "district_id"
    case subdistrictId = "subdistrict_id"
    case villageId = "village_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

struct Province: Codable {
  let id: String
  let name: String
  let isActive: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case isActive = "is_active"
  }
}

struct District: Codable {
  let id: String
  let provinceId: String
  let name: String
  let areaTypeId: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case provinceId = "province_id"
    case areaTypeId = "area_type_id"
  }
}

struct Subdistrict: Codable {
  let id: String
  let districtId: String
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case districtId = "district_id"
  }
}

struct Village: Codable {
  let id: String
  let subdistrictId: String
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case subdistrictId = "subdistrict_id"
  }
}
