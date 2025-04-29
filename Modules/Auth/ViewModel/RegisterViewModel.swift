//
//  RegisterViewModel.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var phone: String = ""
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?
  @Published var user: User?
  
  private let authService = AuthService()
  
  var isFormValid: Bool {
    !name.isEmpty &&
    !email.isEmpty &&
    !password.isEmpty &&
    !phone.isEmpty
  }
  
  func validateForm() -> String? {
    if name.isEmpty { return "Nama tidak boleh kosong" }
    if email.isEmpty { return "Email tidak boleh kosong" }
    if password.isEmpty { return "Password tidak boleh kosong" }
    if phone.isEmpty { return "Nomor telepon tidak boleh kosong" }
    return nil
  }
  
  func register() async {
    isLoading = true
    errorMessage = nil
    
    // Validasi form
    if let validationError = validateForm() {
      errorMessage = validationError
      isLoading = false
      return
    }
    
    do {
      let user = try await authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password
      )
      self.user = user
      print("✅ Registrasi berhasil: User = \(user.name)")
    } catch {
      print("❌ Registrasi error: \(error.localizedDescription)")
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
}
