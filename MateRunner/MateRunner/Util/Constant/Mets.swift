//
//  Mets.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/07.
//

import Foundation

enum Mets: Double {
    case stationary = 0.0
    case walking = 3.8
    case running = 10.0
    
    func value() -> Double {
        return self.rawValue
    }
}
