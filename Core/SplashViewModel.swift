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
    
    init() {
        checkAuthentication()
        checkOnboardingStatus()
    }
    
    func checkAuthentication() {
        isAuthenticated = TokenManager.getToken() != nil
    }
    
    func checkOnboardingStatus() {
        hasSeenOnboarding = TokenManager.hasSeenOnboarding()
    }
    
    func logout() {
        TokenManager.clearToken()
        isAuthenticated = false
    }
    
    func completeOnboarding() {
        TokenManager.markOnboardingAsSeen()
        hasSeenOnboarding = true
    }
}
