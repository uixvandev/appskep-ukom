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
                ProfileView(logoutAction: splashVM.logout)
            } else {
                LoginView(onLoginSuccess: splashVM.checkAuthentication)
            }
        }
        .onAppear {
            splashVM.checkAuthentication()
        }
    }
}


#Preview {
    SplashView()
}
