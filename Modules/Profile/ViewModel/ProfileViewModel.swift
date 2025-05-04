//
//  ProfileViewModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let userService = UserService()
    
    func fetchProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.fetchUserProfile()
            print("✅ Profile loaded successfully: \(user?.name ?? "Unknown")")
        } catch {
            print("❌ Profile loading error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
