//
//  Double+Formatter.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import Foundation

extension Double {
    func doubleToString() -> String {
        return "\(String(format: "%.2f", self))"
    }
    
    func convertToKilometer() -> Double {
        let value = (self) / 10
        return value / 100
    }
}
