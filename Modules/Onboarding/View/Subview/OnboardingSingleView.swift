//
//  OnboardingSingleView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import SwiftUI

struct OnboardingSingleView: View {
  var content: Onboarding
    var body: some View {
      VStack {
        Image(content.image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 248, height: 248)
        
        VStack(spacing: 16) {
          Text(content.title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.neutral100)
          
          Text(content.subtitle)
            .font(.body)
            .foregroundStyle(.neutral80)
            .lineSpacing(4)
        }
        .frame(width: 371)
        .multilineTextAlignment(.center)
      }
    }
}

#Preview {
  OnboardingSingleView(content: Onboarding.data[1])
}
