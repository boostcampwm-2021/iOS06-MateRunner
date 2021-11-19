//
//  Double+Formatter.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
    
    var kilometerString: String {
        var rounded = String(format: "%.3f", self.kilometer)
        _ = rounded.removeLast()
        return String(rounded)
    }
    
    var kilometer: Double {
        guard self != 0 else { return 0 }
        return self / 1000
    }
    
    var meter: Double {
        return self * 1000
    }
}
