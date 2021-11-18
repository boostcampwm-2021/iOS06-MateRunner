//
//  Date+Formatter.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/05.
//

import Foundation

extension Date {
    func korDayOfTheWeekAndTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE a"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
    
    func fullDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd - a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
    
    func fullDateTimeNumberString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
    
    static func secondsToTimeString(from seconds: Int) -> String {
        var time = ""
        
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60
        
        if hour >= 1 {
            time += "\(String(format: "%02d", hour)):"
        }
        
        time += "\(String(format: "%02d", minute)):"
        time += "\(String(format: "%02d", second))"
        
        return time
    }
}
