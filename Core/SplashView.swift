//
//  SplashView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var splashVM = SplashViewModel()
    
    var body: some View {
        Group {
            if splashVM.isAuthenticated {
                // User is logged in, show profile
                ProfileView(logoutAction: splashVM.logout)
            } else if splashVM.hasSeenOnboarding {
                // User has seen onboarding but not logged in, show login
                LoginView(onLoginSuccess: {
                    splashVM.checkAuthentication()
                })
            } else {
                // First-time user, show onboarding
                OnboardingView(onComplete: {
                    splashVM.completeOnboarding()
                })
            }
        }
        .onAppear {
            splashVM.checkAuthentication()
            splashVM.checkOnboardingStatus()
        }
    }
}

#Preview {
    SplashView()
}
