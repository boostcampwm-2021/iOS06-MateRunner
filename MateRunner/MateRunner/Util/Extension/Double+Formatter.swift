//
//  Double+Formatter.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import Foundation

extension Double {
    func string() -> String {
        return "\(floor(self * 100) / 100)"
    }
    
    var kilometerString: String {
        return "\(floor(self.kilometer * 100) / 100)"
    }
    
    var kilometer: Double {
        return self / 1000
    }
    
    var meter: Double {
        return self * 1000
    }
}
