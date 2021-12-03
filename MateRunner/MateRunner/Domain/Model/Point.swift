//
//  Point.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

struct Point: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
