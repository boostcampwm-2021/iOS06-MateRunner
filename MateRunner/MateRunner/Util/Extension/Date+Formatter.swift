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
    
    static func secondsToTimeString(from seconds: Int) -> String {
        var time = ""
        
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60
        
        if hour >= 1 {
            if hour < 10 {
                time += "0" + "\(hour):"
            } else {
                time += "\(hour):"
            }
        }
        
        if minute >= 1 {
            if minute < 10 {
                time += "0" + "\(minute):"
            } else {
                time += "\(minute):"
            }
        }
        
        if second < 10 {
            time += "0" + "\(second)"
        } else {
            time += "\(second)"
        }
        
        return time
    }
}
