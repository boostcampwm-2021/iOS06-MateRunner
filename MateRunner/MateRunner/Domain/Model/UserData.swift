//
//  UserData.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct UserData {
    let nickname: String
    let image: String
    let time: Int
    let distance: Double
    let calorie: Double
    let height: Double
    let weight: Double
    let mate: [String]
    
    init (nickname: String, image: String, height: Double, weight: Double) {
        self.nickname = nickname
        self.image = image
        self.time = 0
        self.distance = 0.0
        self.calorie = 0.0
        self.height = height
        self.weight = weight
        self.mate = []
    }
}
