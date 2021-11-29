//
//  Weight.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/29.
//

import Foundation

enum Weight {
    static let range = [Int](20...300)
    static let minimum = 20
    
    static func toRow(from weight: Double) -> Int {
        return Int(weight) - Self.minimum
    }
}
