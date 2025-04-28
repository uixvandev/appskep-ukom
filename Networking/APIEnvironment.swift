//
//  Environment.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation

enum APIEnvironment {
  
  case auth
  case ukom
  
  var baseURL: URL {
    switch self {
    case .auth:
      return URL(string: "https://dev-auth.appskep.id/v2")!
    case .ukom:
      return URL(string: "https://dev-ukom-backend.appskep.id/v2")!
    }
  }
  
  
}
