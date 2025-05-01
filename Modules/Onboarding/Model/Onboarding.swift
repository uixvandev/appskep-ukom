//
//  Onboarding.swift
//  Appskep Apps
//
//  Created by irfan wahendra on 29/04/25.
//

import Foundation

struct Onboarding: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var subtitle: String
    var tag: Int
}

extension Onboarding {
    static let data: [Onboarding] = [
        Onboarding(
            image: "Onboarding1",
            title: "Belajar Kesehatan Jadi Mudah!",
            subtitle: "Aplikasi bimbel kesehatan No.1 di Indonesia dengan tingkat kelulusan kompetensi 93%.",
            tag: 0
        ),
        
        Onboarding(
            image: "Onboarding2",
            title: "Konten Komprehensif & Akurat",
            subtitle: "Soal try-out mirip ujian nasional, lengkap dengan media belajar yang interaktif dan seru.",
            tag: 1
        ),
        
        Onboarding(
            image: "Onboarding3",
            title: "Performa Belajar Maksimal, Harga Minimal!",
            subtitle: " Pantau progres belajar & diskusi bareng tutor, semua bisa diakses dengan harga terjangkau.",
            tag: 2
        )
    ]
}
