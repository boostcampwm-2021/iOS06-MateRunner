//
//  Date+Formatter.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/05.
//

import Foundation

extension Date {
    var startOfMonth: Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: dateComponents)
    }
    
    var numberOfDays: Int {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var nextMonth: Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    var previousMonth: Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func setDay(to day: Int) -> Date? {
        return Calendar.current.date(bySetting: .day, value: day, of: self)
    }
    
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
    
    func toDateString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
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
    
    var yyyyMMddTHHmmssSSZ: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: self)
    }
    
    func convertToyyyyMMddTHHmmssSSZ(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: dateString)
    }
}
