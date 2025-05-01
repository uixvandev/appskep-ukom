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
  @Published var hasSeenOnboarding: Bool = false
  
  private static let onboardingKey = "hasSeenOnboarding"
  
  init() {
    checkAuthentication()
    checkOnboardingStatus()
  }
  
  func checkAuthentication() {
    isAuthenticated = TokenManager.getToken() != nil
  }
  
  func checkOnboardingStatus() {
    hasSeenOnboarding = UserDefaults.standard.bool(forKey: SplashViewModel.onboardingKey)
  }
  
  func logout() {
    TokenManager.clearToken()
    isAuthenticated = false
  }
  
  func completeOnboarding() {
    UserDefaults.standard.set(true, forKey: SplashViewModel.onboardingKey)
    hasSeenOnboarding = true
  }
}
