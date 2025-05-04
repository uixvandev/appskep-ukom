//
//  LoginView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import SwiftUI

struct LoginView: View {
  @StateObject private var viewModel = LoginViewModel()
  var onLoginSuccess: (() -> Void)?
  @State private var showErrorAlert = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Image("IconLogin")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 86, height: 86)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(spacing: 8) {
          Text("Selamat Datang Kembali!")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("Ayo lanjutkan perjalanan belajarmu dan capai kompetensi maksimal bersama Appskep.")
            .font(.body)
            .foregroundStyle(.neutral90)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        OutlineTextField(
          text: $viewModel.email,
          placeholder: "Masukkan Email",
          fieldType: .text,
          validation: { $0.isEmpty ? "Email tidak boleh kosong" : nil}
        )
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        
        OutlineTextField(
          text: $viewModel.password,
          placeholder: "Masukkan Password",
          fieldType: .secure,
          validation: { $0.count < 6 ? " Minimal 6 karakter" : nil}
        )
        
        if viewModel.isLoading {
          ProgressView()
            .padding()
        } else {
          Button {
            Task {
              await viewModel.login()
              if viewModel.user != nil {
                print("👤 User berhasil login, memanggil handler sukses")
                // Panggil handler sukses untuk navigasi ke MainView
                onLoginSuccess?()
              } else if viewModel.errorMessage != nil {
                showErrorAlert = true
              }
            }
          } label: {
            CustomLongButton(title: "Masuk", titleColor: .white, bgButtonColor: .main)
          }
        }
        
        NavigationLink {
          // Lupa Password View
        } label: {
          Text("Lupa Password")
            .font(.headline)
            .foregroundStyle(.main)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
        NavigationLink {
          RegisterView(onRegisterSuccess: { user in
            // Create a new instance of SplashViewModel and update it
            SplashViewModel.shared.markUserAsNewlyRegistered(user)
            // Call our login success handler which will trigger authentication check
            onLoginSuccess?()
          })
        } label: {
          HStack {
            Text("Belum memiliki akun?")
              .font(.body)
              .foregroundColor(.neutral90)
            Text("Daftar")
              .font(.body)
              .foregroundColor(.main)
              .underline(true)
          }
          .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .padding()
      .navigationBarBackButtonHidden(true)
      .ignoresSafeArea(.keyboard)
      .alert("Login Gagal", isPresented: $showErrorAlert) {
        Button("OK", role: .cancel) { }
      } message: {
        Text(viewModel.errorMessage ?? "Terjadi Kesalahan saat login")
      }
      .onChange(of: viewModel.errorMessage) { _, newValue in
        if newValue != nil {
          showErrorAlert = true
        }
      }
    }
  }
}

#Preview {
  LoginView()
}
