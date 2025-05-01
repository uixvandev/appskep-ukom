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
                // User sudah login, tampilkan MainView bukan ProfileView
                MainView(logoutAction: splashVM.logout)
            } else if splashVM.hasSeenOnboarding {
                // User sudah melihat onboarding tapi belum login, tampilkan login
                LoginView(onLoginSuccess: {
                    splashVM.checkAuthentication()
                })
            } else {
                // Pengguna pertama kali, tampilkan onboarding
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
