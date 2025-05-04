//
//  UserProfileViewModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 02/05/25.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    // User data
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var sex: Int = 1
    @Published var birthdate: String = ""
    @Published var educationInstitutionId: Int = 0
    @Published var provinceId: Int = 0
    @Published var districtId: Int = 0
    @Published var subfieldId: Int = 0
    @Published var subfields: [SubfieldItem] = []
    @Published var isLoadingSubfields: Bool = false
    // UI states
    @Published var isLoading: Bool = false
    @Published var isUpdating: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var user: User?
    
    private let userService = UserService()
    
    // Initialize with current user data
    func setupWithUser(_ user: User) {
        self.user = user
        self.name = user.name
        self.email = user.email
        self.phone = user.phone
        self.sex = user.sex
        self.birthdate = user.birthdate
        self.educationInstitutionId = user.institutionId
        self.provinceId = user.provinceId
        self.districtId = user.districtId
        self.subfieldId = user.subfieldId
    }
    
    // Fetch current user profile
    func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await userService.fetchUserProfile()
            setupWithUser(user)
            print("✅ Profile fetched successfully: \(user.name)")
        } catch {
            errorMessage = "Error fetching profile: \(error.localizedDescription)"
            print("❌ Profile fetch error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // Update user profile then fetch updated data
    func updateAndFetchProfile() async -> User? {
        isUpdating = true
        errorMessage = nil
        successMessage = nil
        
        do {
            // Pertama update profile menggunakan requestRaw
            try await userService.updateUserProfile(
                name: name,
                phone: phone,
                email: email,
                sex: sex,
                education_Institution_Id: educationInstitutionId,
                address_province_id: provinceId,
                address_district_id: districtId,
                subfield_id: subfieldId,
                birth_date: birthdate
            )
            
            // Berikan delay kecil untuk memastikan server telah memproses update
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 detik
            
            // Kemudian fetch profile yang sudah diupdate menggunakan endpoint GET
            let updatedUser = try await userService.fetchUserProfile()
            
            // Update state lokal dengan data baru
            setupWithUser(updatedUser)
            
            successMessage = "Profil berhasil diperbarui"
            print("✅ Profile updated and fetched successfully: \(updatedUser.name)")
            
            isUpdating = false
            return updatedUser
            
        } catch {
            errorMessage = "Error updating profile: \(error.localizedDescription)"
            print("❌ Profile update error: \(error.localizedDescription)")
            isUpdating = false
            return nil
        }
    }
    
    // Validate form before submission
    func validateForm() -> Bool {
        if name.isEmpty {
            errorMessage = "Nama tidak boleh kosong"
            return false
        }
        
        if email.isEmpty {
            errorMessage = "Email tidak boleh kosong"
            return false
        }
        
        // Add more validation as needed
        return true
    }
  
  // Method untuk memuat data subfields
  func loadSubfields() async {
      isLoadingSubfields = true
      
      do {
          subfields = try await userService.fetchSubfields()
          print("✅ Berhasil memuat \(subfields.count) subfields")
      } catch {
          print("❌ Gagal memuat subfields: \(error.localizedDescription)")
          errorMessage = "Gagal memuat data bidang keahlian"
      }
      
      isLoadingSubfields = false
  }
}
