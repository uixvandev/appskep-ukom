//
//  EditProfileView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 02/05/25.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    var user: User
    var onProfileUpdated: ((User) -> Void)?
    
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    Circle()
                        .fill(Color.main.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(String(user.name.prefix(1)))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.main)
                        )
                        .padding(.top, 10)
                    
                    // Profile form fields
                    VStack(spacing: 16) {
                        OutlineTextField(
                            text: $viewModel.name,
                            placeholder: "Nama Lengkap",
                            fieldType: .text,
                            validation: { $0.isEmpty ? "Nama tidak boleh kosong" : nil }
                        )
                        
                        OutlineTextField(
                            text: $viewModel.email,
                            placeholder: "Email",
                            fieldType: .text,
                            validation: { $0.isEmpty ? "Email tidak boleh kosong" : nil }
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disabled(true) // Email tidak bisa diedit
                        
                        OutlineTextField(
                            text: $viewModel.phone,
                            placeholder: "Nomor Telepon",
                            fieldType: .text,
                            validation: { $0.isEmpty ? "Nomor telepon tidak boleh kosong" : nil }
                        )
                        .keyboardType(.phonePad)
                        
                        // Tanggal Lahir - disederhanakan, idealnya gunakan DatePicker
                        OutlineTextField(
                            text: $viewModel.birthdate,
                            placeholder: "Tanggal Lahir (YYYY-MM-DD)",
                            fieldType: .text,
                            validation: nil
                        )
                        
                        // Untuk pemilihan jenis kelamin - disederhanakan
                        HStack {
                            Text("Jenis Kelamin:")
                                .foregroundColor(.neutral90)
                            
                            Picker("", selection: $viewModel.sex) {
                                Text("Laki-laki").tag(1)
                                Text("Perempuan").tag(2)
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.vertical, 8)
                        
                        // Tambahkan field lain sesuai kebutuhan untuk institusi, provinsi, dll.
                    }
                    
                    // Tombol Submit
                    if viewModel.isUpdating {
                        ProgressView()
                            .padding()
                    } else {
                        Button {
                            Task {
                                if viewModel.validateForm() {
                                    if let updatedUser = await viewModel.updateAndFetchProfile() {
                                        showSuccessAlert = true
                                        onProfileUpdated?(updatedUser)
                                    } else {
                                        showErrorAlert = true
                                    }
                                } else {
                                    showErrorAlert = true
                                }
                            }
                        } label: {
                            CustomLongButton(
                                title: "Simpan Perubahan",
                                titleColor: .white,
                                bgButtonColor: .main
                            )
                        }
                        .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Edit Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                    .foregroundColor(.main)
                }
            }
            .alert("Profil Diperbarui", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(viewModel.successMessage ?? "Profil berhasil diperbarui")
            }
            .alert("Gagal", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Terjadi kesalahan saat memperbarui profil")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setupWithUser(user)
        }
    }
}

#Preview {
    // Create a sample user for preview
    let sampleUser = User(
        id: 1,
        uuid: "123",
        username: "sample",
        email: "user@example.com",
        phone: "08123456789",
        name: "Sample User",
        nickname: "",
        birthplace: "",
        birthdate: "",
        sex: 1,
        educationLevel: 1,
        educationLevelText: "",
        workInstitutionName: "",
        workInstitutionId: 0,
        institutionId: 1,
        provinceId: 1,
        districtId: 1,
        subdistrictId: 1,
        villageId: 1,
        address: "Jl. Sample Address",
        isOrganizer: 0,
        status: 1,
        confirmedAt: 0,
        twoFactorAuthentication: nil,
        reviewStatus: 0,
        subfieldId: 0,
        createdAt: 0,
        updatedAt: 0,
        subfield: Subfield(id: 1, text: "", fieldId: nil, description: nil, createdBy: nil, updatedBy: nil, createdAt: nil, updatedAt: nil),
        institution: Institution(id: 1, name: "Sample Institution", code: "", type: 0, mergedTo: 0, provinceId: "", districtId: "", subdistrictId: "", villageId: "", address: "", createdAt: 0, updatedAt: 0, province: Province(id: "", name: "", isActive: 1), district: District(id: "", provinceId: "", name: "", areaTypeId: 0)),
        workInstitution: nil,
        province: Province(id: "1", name: "Sample Province", isActive: 1),
        district: District(id: "1", provinceId: "1", name: "Sample District", areaTypeId: 1),
        subdistrict: nil,
        village: nil
    )
    
    return EditProfileView(user: sampleUser)
}
