//
//  TokenManager.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 28/04/25.
//

import Foundation

class TokenManager {
    private static let tokenKey = "auth_token"
    
    static func saveToken(_ token: String) {
        print("💾 Menyimpan token: \(token.prefix(10))...")
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        if let token = token {
            print("🔐 Mengambil token: \(token.prefix(10))...")
        } else {
            print("⚠️ Tidak ada token yang ditemukan di penyimpanan")
        }
        return token
    }
    
    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        print("🗑️ Token dihapus dari penyimpanan")
    }
}
