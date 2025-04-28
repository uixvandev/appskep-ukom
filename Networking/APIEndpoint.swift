//
//  APIEndpoint.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 27/04/25.
//

import Foundation

enum APIEndpoint {
  
  //AUTH
  case login
  case register
  case getUser
  
  //UKOM
  
  
  
  var path: String {
    switch self {
    case .login:
      return "/api/login"
    case .register:
      return "/api/register"
    case .getUser:
      return "/user/me"
    }
  }
}
