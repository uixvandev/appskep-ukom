//
//  RegisterView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import SwiftUI

struct RegisterView: View {
  @StateObject private var viewModel = RegisterViewModel()
  @ObservedObject private var sharedViewModel = SplashViewModel.shared
  @Environment(\.dismiss) private var dismiss
  @State private var isCheckPolicy: Bool = false
  @State private var showErrorAlert = false
  @State private var startExitAnimation = false
  var onRegisterSuccess: ((User) -> Void)?
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Image("IconRegister")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 86, height: 86)
          .frame(maxWidth: .infinity, alignment: .leading)
          .opacity(startExitAnimation ? 0 : 1)
          .offset(y: startExitAnimation ? -20 : 0)
        
        VStack(spacing: 8) {
          Text("Daftar & Mulai Perjalananmu!")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(startExitAnimation ? 0 : 1)
            .offset(y: startExitAnimation ? -15 : 0)
          
          Text("Gabung bersama ribuan pengguna APPSKEP, siapkan UKOM metode efektif dan interaktif.")
            .font(.body)
            .foregroundStyle(.neutral90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(startExitAnimation ? 0 : 1)
            .offset(y: startExitAnimation ? -10 : 0)
        }
        
        Group {
          OutlineTextField(
            text: $viewModel.name,
            placeholder: "Nama",
            fieldType: .text,
            validation: { $0.isEmpty ? "Nama tidak boleh kosong" : nil}
          )
          .textInputAutocapitalization(.words)
          
          OutlineTextField(
            text: $viewModel.email,
            placeholder: "Email",
            fieldType: .text,
            validation: { $0.isEmpty ? "Email tidak boleh kosong" : nil}
          )
          .keyboardType(.emailAddress)
          .textInputAutocapitalization(.never)
          
          OutlineTextField(
            text: $viewModel.phone,
            placeholder: "Nomor HP/Whatsapp",
            fieldType: .text,
            validation: { $0.isEmpty ? "Nomor HP tidak boleh kosong" : nil}
          )
          .keyboardType(.numberPad)
          .textInputAutocapitalization(.never)
          
          OutlineTextField(
            text: $viewModel.password,
            placeholder: "Password",
            fieldType: .secure,
            validation: { $0.count < 6 ? " Minimal 6 karakter" : nil}
          )
        }
        .opacity(startExitAnimation ? 0 : 1)
        .offset(y: startExitAnimation ? -5 : 0)
        
        HStack(spacing: 8){
          //square check mark
          Image(systemName: isCheckPolicy ? "checkmark.square.fill" : "square" )
            .onTapGesture {
              isCheckPolicy.toggle()
            }
            .foregroundStyle(isCheckPolicy ? .main : .main)
            .font(.largeTitle)
          
          //text
          Text("Saya menyetujui **[Syarat dan ketentuan](https://iswift.mayar.link)** serta **[Kebijakan Privasi](https://google.com)** Appskep.")
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(startExitAnimation ? 0 : 1)
        .offset(y: startExitAnimation ? 0 : 0)
        
        if viewModel.isLoading {
          ProgressView()
            .padding()
        } else {
          Button {
            Task {
              await registerWithAnimation()
            }
          } label: {
            CustomLongButton(title: "Daftar", titleColor: .white, bgButtonColor: .main.opacity(isCheckPolicy ? 1 : 0.5))
          }
          .disabled(!isCheckPolicy)
          .opacity(startExitAnimation ? 0 : 1)
          .offset(y: startExitAnimation ? 5 : 0)
        }
        
        HStack{
          Text("Sudah memiliki akun?")
            .font(.body)
          Button("Masuk") {
            dismiss()
          }
          .font(.body)
        }
        .opacity(startExitAnimation ? 0 : 1)
        .offset(y: startExitAnimation ? 10 : 0)
      }
      .padding()
    }
    .navigationBarBackButtonHidden(true)
    .alert("Registrasi Gagal", isPresented: $showErrorAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(viewModel.errorMessage ?? "Terjadi Kesalahan saat registrasi")
    }
    .onChange(of: viewModel.errorMessage) { _, newValue in
      if newValue != nil {
        showErrorAlert = true
      }
    }
  }
  
  // Function to handle registration with animation
  private func registerWithAnimation() async {
    await viewModel.register()
    
    if let user = viewModel.user {
      print("👤 User terdaftar, memanggil handler sukses")
      
      // Start exit animation
      withAnimation(.easeIn(duration: 0.4)) {
        startExitAnimation = true
      }
      
      // Wait for animation to complete
      try? await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
      
      // Mark user as newly registered and trigger navigation
      sharedViewModel.markUserAsNewlyRegistered(user)
      onRegisterSuccess?(user)
      dismiss()
    } else if viewModel.errorMessage != nil {
      showErrorAlert = true
    }
  }
}

#Preview {
  RegisterView()
}
