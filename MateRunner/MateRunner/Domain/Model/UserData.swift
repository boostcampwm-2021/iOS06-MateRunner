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
    
    init (
        nickname: String = "",
        image: String = "",
        time: Int = 0,
        distance: Double = 0.0,
        calorie: Double = 0.0,
        height: Double = 0.0,
        weight: Double = 0.0,
        mate: [String] = []
    ) {
        self.nickname = nickname
        self.image = image
        self.time = time
        self.distance = distance
        self.calorie = calorie
        self.height = height
        self.weight = weight
        self.mate = mate
    }
}
