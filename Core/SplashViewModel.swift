//
//  splashViewModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
  @Published var isAuthenticated: Bool = false
  
  init() {
    checkAuthentication()
  }
  
  func checkAuthentication() {
    let hasToken = TokenManager.getToken() != nil
    print("🔑 Token exists: \(hasToken)")
    isAuthenticated = hasToken
  }
  
  func logout() {
    TokenManager.clearToken()
    isAuthenticated = false
    print("🚪 User logged out")
  }
}
