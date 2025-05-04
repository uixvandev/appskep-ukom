//
//  SplashView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import SwiftUI

struct SplashView: View {
  @ObservedObject private var splashVM = SplashViewModel.shared
  @State private var isTransitioning = false
  
  var body: some View {
    Group {
      if splashVM.isAuthenticated {
        if splashVM.isNewRegistration, let user = splashVM.newlyRegisteredUser {
          // New user that needs to complete profile
          ProfileCompletionView(user: user) {
            // When profile completion is done
            withAnimation(.easeInOut(duration: 0.3)) {
              isTransitioning = true
            }
            
            // Add delay before navigating
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              splashVM.markProfileCompleted()
              splashVM.checkAuthentication()
              
              // Reset transition state
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTransitioning = false
              }
            }
          }
          .opacity(isTransitioning ? 0 : 1)
          .transition(.opacity)
        } else {
          // Regular authenticated user
          MainView(logoutAction: splashVM.logout)
            .transition(.opacity)
            .animation(.easeInOut, value: splashVM.isAuthenticated)
        }
      } else if splashVM.hasSeenOnboarding {
        // User sudah melihat onboarding tapi belum login, tampilkan login
        LoginView(onLoginSuccess: {
          withAnimation(.easeInOut) {
            splashVM.checkAuthentication()
          }
        })
        .transition(.opacity)
        .animation(.easeInOut, value: splashVM.hasSeenOnboarding)
      } else {
        // Pengguna pertama kali, tampilkan onboarding
        OnboardingView(onComplete: {
          withAnimation(.easeInOut) {
            splashVM.completeOnboarding()
          }
        })
        .transition(.opacity)
        .animation(.easeInOut, value: splashVM.hasSeenOnboarding)
      }
    }
    .onAppear {
      splashVM.checkAuthentication()
      splashVM.checkOnboardingStatus()
      splashVM.checkProfileStatus()
    }
  }
}

#Preview {
  SplashView()
}
