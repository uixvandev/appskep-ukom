//
//  RegisterView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import SwiftUI

struct RegisterView: View {
  @StateObject private var viewModel = RegisterViewModel()
  @Environment(\.dismiss) private var dismiss
  @State private var isCheckPolicy: Bool = false
  @State private var showErrorAlert = false
  var onRegisterSuccess: (() -> Void)?
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Image("IconRegister")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 86, height: 86)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(spacing: 8) {
          Text("Daftar & Mulai Perjalananmu!")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("Gabung bersama ribuan pengguna APPSKEP, siapkan UKOM metode efektif dan interaktif.")
            .font(.body)
            .foregroundStyle(.neutral90)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
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
        
        if viewModel.isLoading {
          ProgressView()
            .padding()
        } else {
          Button {
            Task {
              await viewModel.register()
              if viewModel.user != nil {
                print("👤 User terdaftar, memanggil handler sukses")
                onRegisterSuccess?()
              } else if viewModel.errorMessage != nil {
                showErrorAlert = true
              }
            }
          } label: {
            CustomLongButton(title: "Daftar", titleColor: .white, bgButtonColor: .main.opacity(isCheckPolicy ? 1 : 0.5))
          }
          .disabled(!isCheckPolicy)
        }
        HStack{
          Text("Sudah memiliki akun?")
            .font(.body)
          Button("Masuk") {
            dismiss()
          }
          .font(.body)
          
        }
        
      }
      .padding()
    }
    .navigationBarBackButtonHidden(true)
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

#Preview {
  RegisterView()
}
