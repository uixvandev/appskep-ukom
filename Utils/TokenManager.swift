//
//  TokenManager.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

final class TokenManager {
    private static let accessTokenKey = "accessToken"
    private static let hasSeenOnboardingKey = "hasSeenOnboarding"

    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    static func getToken() -> String? {
        UserDefaults.standard.string(forKey: accessTokenKey)
    }

    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }
    
    // Add methods to track onboarding status
    static func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
    }
    
    static func hasSeenOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    static func resetOnboardingStatus() {
        UserDefaults.standard.set(false, forKey: hasSeenOnboardingKey)
    }
}
