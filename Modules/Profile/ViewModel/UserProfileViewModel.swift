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
      
    } catch let error as NSError {
      if error.code == 401 {
        errorMessage = "Sesi login Anda telah berakhir. Silakan login kembali."
        print("❌ Profile update error: 401 Unauthorized - Session expired")
        // Bisa tambahkan logika untuk logout otomatis dan kembali ke halaman login
      } else {
        errorMessage = "Error updating profile: \(error.localizedDescription)"
        print("❌ Profile update error: \(error.localizedDescription)")
      }
      isUpdating = false
      return nil
    }
  }
  
  // Validate form before submission
  func validateForm() -> Bool {
    var isValid = true
    errorMessage = nil
    
    // Validate name
    if name.isEmpty {
      errorMessage = "Nama tidak boleh kosong"
      isValid = false
    }
    
    // Validate email
    if email.isEmpty {
      errorMessage = "Email tidak boleh kosong"
      isValid = false
    }
    
    // Validate phone
    if phone.isEmpty {
      errorMessage = "Nomor telepon tidak boleh kosong"
      isValid = false
    }
    
    // Validate birthdate
    if birthdate.isEmpty {
      errorMessage = "Tanggal lahir tidak boleh kosong"
      isValid = false
    } else {
      // Check format is YYYY-MM-DD
      let dateRegex = #"^\d{4}-\d{2}-\d{2}$"#
      let dateCheck = NSPredicate(format: "SELF MATCHES %@", dateRegex)
      if !dateCheck.evaluate(with: birthdate) {
        errorMessage = "Format tanggal lahir harus YYYY-MM-DD (contoh: 2000-01-31)"
        isValid = false
      }
    }
    
    // Validate subfield
    if subfieldId <= 0 {
      errorMessage = "Bidang keahlian harus dipilih"
      isValid = false
    }
    
    return isValid
  }
  
  // Method untuk memuat data subfields
  func loadSubfields() async {
    isLoadingSubfields = true
    
    do {
      let userService = UserService()
      subfields = try await userService.fetchSubfields()
      print("✅ Fetched \(subfields.count) subfields")
    } catch {
      print("❌ Gagal memuat subfields: \(error.localizedDescription)")
      errorMessage = "Gagal memuat data bidang keahlian"
    }
    
    isLoadingSubfields = false
  }
}
