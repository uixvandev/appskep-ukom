//
//  SubfieldDropdownView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 04/05/25.
//

import SwiftUI

struct SubfieldDropdownView: View {
    @Binding var selectedId: Int
    let subfields: [SubfieldItem]
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bidang Keahlian")
                .font(.headline)
                .foregroundStyle(.neutral90)
            
            if isLoading {
                HStack {
                    ProgressView()
                        .padding(.trailing, 8)
                    Text("Memuat bidang keahlian...")
                        .foregroundStyle(.neutral80)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemGray6))
                )
            } else {
                Menu {
                    ForEach(subfields) { item in
                        Button(item.text) {
                            selectedId = item.id
                        }
                    }
                } label: {
                    HStack {
                        Text(getSubfieldName())
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.systemGray6))
                    )
                }
            }
        }
    }
    
    private func getSubfieldName() -> String {
        if let subfield = subfields.first(where: { $0.id == selectedId }) {
            return subfield.text
        }
        return "Pilih Bidang Keahlian"
    }
}

#Preview {
    // Buat state lokal untuk simulasi binding
    struct PreviewWrapper: View {
        @State private var selectedId: Int = 1
        
        var body: some View {
            SubfieldDropdownView(
                selectedId: $selectedId,
                subfields: [
                    SubfieldItem(
                        id: 1,
                        text: "NERS",
                        fieldId: 1,
                        description: "",
                        createdBy: nil,
                        updatedBy: nil,
                        createdAt: nil,
                        updatedAt: nil
                    ),
                    SubfieldItem(
                        id: 2,
                        text: "D3 Keperawatan",
                        fieldId: 1,
                        description: "",
                        createdBy: nil,
                        updatedBy: nil,
                        createdAt: nil,
                        updatedAt: nil
                    ),
                    SubfieldItem(
                        id: 3,
                        text: "D3 Kebidanan",
                        fieldId: 2,
                        description: "",
                        createdBy: nil,
                        updatedBy: nil,
                        createdAt: nil,
                        updatedAt: nil
                    )
                ],
                isLoading: false
            )
            .padding()
        }
    }
    
    return PreviewWrapper()
}
