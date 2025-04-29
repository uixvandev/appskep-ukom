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
    var onRegisterSuccess: (() -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.vertical, 20)
                
                Text("Buat Akun")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Form fields
                VStack(spacing: 15) {
                    TextField("Nama Lengkap", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    TextField("Nomor Telepon (contoh: +628123456789)", text: $viewModel.phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button("Daftar") {
                        Task {
                            await viewModel.register()
                            if viewModel.user != nil {
                                print("👤 User terdaftar, memanggil handler sukses")
                                onRegisterSuccess?()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Button("Sudah punya akun? Masuk") {
                    dismiss()
                }
                .font(.footnote)
                .padding(.bottom)
            }
            .padding()
        }
        .navigationTitle("Register")
    }
}

#Preview {
    RegisterView()
}
