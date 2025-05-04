//
//  ProfileView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var logoutAction: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.user {
                        // Profile Header
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color.main.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text(String(user.name.prefix(1)))
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.main)
                                )
                            
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 30)
                        
                        // User Details
                        VStack(alignment: .leading, spacing: 20) {
                            infoRow(title: "Phone", value: user.phone.isEmpty ? "-" : user.phone)
                            infoRow(title: "Institution", value: user.institution.name.isEmpty ? "-" : user.institution.name)
                            infoRow(title: "Address", value: user.address.isEmpty ? "-" : user.address)
                            infoRow(title: "Province", value: user.province.name.isEmpty ? "-" : user.province.name)
                            infoRow(title: "District", value: user.district.name.isEmpty ? "-" : user.district.name)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                        
                        // Edit Profile Button
                        NavigationLink {
                            EditProfileView(user: user) { updatedUser in
                                // Update the profile view with the updated user
                                viewModel.user = updatedUser
                            }
                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profil")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.main)
                            )
                        }
                        .padding(.top, 20)
                        
                    } else if viewModel.isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Loading profile...")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                            
                            Text("Failed to load profile")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(errorMessage)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Button("Try Again") {
                                Task {
                                    await viewModel.fetchProfile()
                                }
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 10)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    Button {
                        logoutAction()
                    } label: {
                        CustomLongButton(
                            title: "Logout",
                            titleColor: .white,
                            bgButtonColor: Color.red
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.fetchProfile()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchProfile()
            }
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.gray)
            
            Text(value)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
}

#Preview {
    ProfileView(logoutAction: {
        print("logout tapped in preview")
    })
}
