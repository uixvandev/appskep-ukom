//
//  MainView.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 01/05/25.
//

import SwiftUI

struct MainView: View {
    var logoutAction: () -> Void
    
    var body: some View {
        TabView {
            // Tab Beranda
            NavigationStack {
                VStack {
                    Text("Layar Beranda")
                        .font(.title)
                        .padding()
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .padding()
                    
                    Text("Selamat Datang di Appskep")
                        .font(.headline)
                }
                .navigationTitle("Dashboard")
            }
            .tabItem {
                Label("Beranda", systemImage: "house")
            }
          SearchUkomPackage()
            .tabItem {
              Label("Pencarian", systemImage: "magnifyingglass")
            }
          
          UkomMyPackage()
            .tabItem {
              Label("Paket Saya", systemImage: "folder")
            }
          
          ProfileView(logoutAction: logoutAction)
              .tabItem {
                  Label("Profil", systemImage: "person")
              }
        }
    }
}

#Preview {
    MainView(logoutAction: {
        print("Logout ditekan")
    })
}
