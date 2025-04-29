//
//  CustomDotIndicator.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import SwiftUI

struct CustomDotIndicator: View {
  let count: Int
  @Binding var selectedTab: Int
  
  var body: some View {
    HStack {
      ForEach(0..<count, id: \.self) { tab in
        Circle()
          .fill(tab == selectedTab ? Color(.blue100) : Color(.blue10))
          .scaleEffect(tab == selectedTab ? 2.0 : 1.0)
          .frame(width: 8, height: 8)
          .padding(.horizontal, 4)
          .onTapGesture {
            selectedTab = tab
          }
      }
    }
    .animation(.easeOut, value: selectedTab)
  }
}

#Preview {
  @Previewable @State var selectedTab: Int = 0
  CustomDotIndicator(count: 3, selectedTab: $selectedTab)
}
