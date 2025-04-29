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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .padding(.vertical, 20)
                
                Text("Login to Appskep")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button {
                        Task {
                            await viewModel.login()
                            if viewModel.user != nil {
                                print("👤 User logged in, calling success handler")
                                onLoginSuccess?()
                            }
                        }
                    } label: {
                        CustomLongButton(title: "Masuk", titleColor: .white, bgButtonColor: .blue100)
                    }
                    .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                NavigationLink {
                    RegisterView(onRegisterSuccess: onLoginSuccess)
                } label: {
                    Text("Belum punya akun? Daftar")
                        .font(.footnote)
                        .foregroundColor(.blue100)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginView()
}
