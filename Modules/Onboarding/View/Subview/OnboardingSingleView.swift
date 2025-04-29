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
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.dark)
          
          Text(content.subtitle)
            .font(.subheadline)
            .foregroundStyle(.light20)
            .lineSpacing(4)
        }
        .frame(width: 371)
        .multilineTextAlignment(.center)
      }
    }
}

#Preview {
  OnboardingSingleView(content: Onboarding.data[0])
}
