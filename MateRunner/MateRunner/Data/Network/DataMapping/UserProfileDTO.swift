//
//  UserProfileDTO.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

struct UserProfileDTO: Codable {
    let name: String
    let image: String
    let time: Int
    let distance: Double
    let calorie: Double
    let height: Double
    let weight: Double
    let mate: [String]
    
    init() {
        self.name = ""
        self.image = ""
        self.time = 0
        self.distance = 0.0
        self.calorie = 0.0
        self.height = 0.0
        self.weight = 0.0
        self.mate = []
    }
}
