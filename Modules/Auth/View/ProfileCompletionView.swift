//
//  ProfileCompletionView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 04/05/25.
//

import SwiftUI

struct ProfileCompletionView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var animateContent = false
    @State private var selectedDate = Date()
    @Environment(\.colorScheme) private var colorScheme
    var user: User
    var onProfileCompleted: (() -> Void)
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        return !viewModel.name.isEmpty &&
        !viewModel.email.isEmpty &&
        !viewModel.phone.isEmpty &&
        !viewModel.birthdate.isEmpty &&
        viewModel.subfieldId > 0
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with gradient background
                    VStack(spacing: 20) {
                        Image("IconRegister")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(animateContent ? 1.0 : 0.6)
                                    .blur(radius: 2)
                            )
                        
                        VStack(spacing: 6) {
                            Text("Lengkapi Profil Anda")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .offset(y: animateContent ? 0 : 20)
                            
                            Text("Satu langkah lagi menuju pengalaman belajar yang lebih personal")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 20)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .offset(y: animateContent ? 0 : 15)
                        }
                    }
                    .frame(width: geo.size.width)
                    .frame(minHeight: 220)
                    .padding(.top, 20)
                    .padding(.bottom, 45)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.main, Color.main.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    // Form card with shadow
                    VStack(spacing: 24) {
                        // Form Fields
                        VStack(spacing: 22) {
                            // Personal info section
                            formSection(title: "Informasi Dasar") {
                                // Nama (sudah diisi dari registrasi)
                                formField(
                                    title: "Nama Lengkap",
                                    field: OutlineTextField(
                                        text: $viewModel.name,
                                        placeholder: "Nama Lengkap",
                                        fieldType: .text,
                                        validation: { $0.isEmpty ? "Nama tidak boleh kosong" : nil }
                                    )
                                    .disabled(true)
                                )
                                
                                // Email (sudah diisi dari registrasi)
                                formField(
                                    title: "Email",
                                    field: OutlineTextField(
                                        text: $viewModel.email,
                                        placeholder: "Email",
                                        fieldType: .text,
                                        validation: { $0.isEmpty ? "Email tidak boleh kosong" : nil }
                                    )
                                    .disabled(true)
                                )
                                
                                // Nomor Telepon
                                formField(
                                    title: "Nomor Telepon",
                                    field: OutlineTextField(
                                        text: $viewModel.phone,
                                        placeholder: "Nomor Telepon",
                                        fieldType: .text,
                                        validation: { $0.isEmpty ? "Nomor telepon tidak boleh kosong" : nil }
                                    )
                                )
                            }
                            
                            Divider()
                                .background(Color.neutral80.opacity(0.5))
                                .padding(.horizontal, -16)
                            
                            // Additional info section
                            formSection(title: "Detail Pribadi") {
                                // Tanggal Lahir
                                formField(
                                    title: "Tanggal Lahir",
                                    field: ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.neutral80, lineWidth: 1)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                                            )
                                            .frame(height: 50)
                                        
                                        DatePicker(
                                            "",
                                            selection: $selectedDate,
                                            displayedComponents: [.date]
                                        )
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .padding(.horizontal, 12)
                                        .onChange(of: selectedDate) { _, newValue in
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd"
                                            viewModel.birthdate = formatter.string(from: newValue)
                                        }
                                    }
                                )
                                
                                // Jenis Kelamin
                                formField(
                                    title: "Jenis Kelamin",
                                    field: ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.neutral80, lineWidth: 1)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                                            )
                                        
                                        Picker("", selection: $viewModel.sex) {
                                            Text("Laki-laki").tag(1)
                                            Text("Perempuan").tag(2)
                                        }
                                        .pickerStyle(.segmented)
                                        .padding(8)
                                    }
                                    .frame(height: 50)
                                )
                                
                                // Bidang Keahlian
                                formField(
                                    title: "Bidang Keahlian",
                                    field: SubfieldDropdownView(
                                        selectedId: $viewModel.subfieldId,
                                        subfields: viewModel.subfields,
                                        isLoading: viewModel.isLoadingSubfields
                                    )
                                )
                            }
                        }
                        .padding(.top, 16)
                        
                        // Submit Button with gradient
                        VStack(spacing: 12) {
                            if viewModel.isUpdating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.main))
                                    .scaleEffect(1.2)
                                    .frame(height: 55)
                                    .opacity(animateContent ? 1.0 : 0.0)
                            } else {
                                Button {
                                    Task {
                                        if viewModel.validateForm() {
                                            if let _ = await viewModel.updateAndFetchProfile() {
                                                onProfileCompleted()
                                            } else {
                                                showErrorAlert = true
                                            }
                                        } else {
                                            showErrorAlert = true
                                        }
                                    }
                                } label: {
                                    Text("Simpan & Lanjutkan")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(
                                            isFormValid ?
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.main, Color.main.opacity(0.8)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ) :
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(16)
                                        .shadow(color: isFormValid ? Color.main.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                                }
                                .disabled(!isFormValid)
                                .padding(.vertical, 8)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .offset(y: animateContent ? 0 : 10)
                            }
                            
                            if !isFormValid {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    
                                    Text("Lengkapi semua informasi untuk melanjutkan")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.bottom, 8)
                                .opacity(animateContent ? 1.0 : 0.0)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(colorScheme == .dark ? Color(.systemBackground) : Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: -5)
                    )
                    .offset(y: -40)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .scaleEffect(animateContent ? 1.0 : 0.95, anchor: .top)
                }
                .edgesIgnoringSafeArea(.top)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Perhatian"),
                    message: Text(viewModel.errorMessage ?? "Terjadi kesalahan saat memperbarui profil"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            viewModel.setupWithUser(user)
            
            // Initialize date picker with user's birthdate if available
            if !user.birthdate.isEmpty {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let date = formatter.date(from: user.birthdate) {
                    selectedDate = date
                }
            } else {
                // Set a default date (18 years ago)
                if let date18YearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: Date()) {
                    selectedDate = date18YearsAgo
                    
                    // Also set the string value immediately
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    viewModel.birthdate = formatter.string(from: selectedDate)
                }
            }
            
            Task {
                await viewModel.loadSubfields()
            }
            
            // Animate content with a slight delay
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    // Helper function to create form sections
    @ViewBuilder
    private func formSection<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            content()
        }
    }
    
    // Helper function to create consistent form fields with titles only
    @ViewBuilder
    private func formField<Content: View>(title: String, field: Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary.opacity(0.8))
            
            field
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
    
    return ProfileCompletionView(user: sampleUser, onProfileCompleted: {})
}
