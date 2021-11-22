//
//  UserProfile.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

struct UserProfileDTO: Codable {
    let nickname: String
    let image: String
    let time: Int
    let distance: Double
    let calorie: Double
}
