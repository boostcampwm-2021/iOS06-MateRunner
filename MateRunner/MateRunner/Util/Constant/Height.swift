//
//  Height.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/29.
//

import Foundation

enum Height {
    static let range = [Int](100...250)
    static let minimum = 100
    
    static func toRow(from height: Double) -> Int {
        return Int(height) - Self.minimum
    }
}
