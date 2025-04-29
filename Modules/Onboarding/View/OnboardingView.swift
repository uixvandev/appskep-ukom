//
//  OnboardingView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import SwiftUI

struct OnboardingView: View {
    private let tabs: [Onboarding] = Onboarding.data
    @State private var selectedTab = 0
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                ForEach(tabs) { tab in
                    Group {
                        OnboardingSingleView(content: tab)
                    }
                    .tag(tab.tag)
                }
            }
            .animation(.smooth, value: selectedTab)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            
            CustomDotIndicator(count: tabs.count, selectedTab: $selectedTab)
                .padding([.top, .bottom], 32)
            
            VStack(spacing: 16) {
                Button {
                    // Mark onboarding as complete and show login
                    onComplete?()
                } label: {
                    CustomLongButton(title: "Masuk", titleColor: Color.white, bgButtonColor: Color.blue100)
                }
                
                Button {
                    // Mark onboarding as complete and show register
                    onComplete?()
                } label: {
                    CustomLongButton(title: "Daftar", titleColor: Color.blue100, bgButtonColor: Color.blue10)
                }
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    OnboardingView()
}
