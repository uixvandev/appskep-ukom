//
//  LoginViewModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var user: User?

    private let authService = AuthService()
    
    func login() async {
        isLoading = true
        errorMessage = nil
        do {
          let user = try await authService.login(email: email, password: password)
            self.user = user
            print("✅ Login successful: User = \(user.name)")
        } catch {
            print("❌ Login error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
