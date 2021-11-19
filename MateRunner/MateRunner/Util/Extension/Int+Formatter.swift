//
//  Int+Formatter.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = self % 60
        
        if hour >= 100 { return "\(hour)" }
        return (hour < 1 ? "" : String(format: "%02d", hour)) + String(format: "%02d:%02d", minute, second)
    }
}
