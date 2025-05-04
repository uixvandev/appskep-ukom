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
  @Published var isNewRegistration: Bool = false
  @Published var newlyRegisteredUser: User?
  
  private static let onboardingKey = "hasSeenOnboarding"
  private static let profileCompletedKey = "profileCompleted"
  // Add a static shared instance property
  static let shared = SplashViewModel()
  
  init() {
    checkAuthentication()
    checkOnboardingStatus()
    checkProfileStatus()
  }
  func markUserAsNewlyRegistered(_ user: User) {
      isNewRegistration = true
      newlyRegisteredUser = user
      // Remove any existing profile completed flag
      UserDefaults.standard.removeObject(forKey: SplashViewModel.profileCompletedKey)
  }

  func markProfileCompleted() {
      UserDefaults.standard.set(true, forKey: SplashViewModel.profileCompletedKey)
      isNewRegistration = false
      newlyRegisteredUser = nil
  }

  func checkProfileStatus() {
      let profileCompleted = UserDefaults.standard.bool(forKey: SplashViewModel.profileCompletedKey)
      if profileCompleted {
          isNewRegistration = false
      }
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
