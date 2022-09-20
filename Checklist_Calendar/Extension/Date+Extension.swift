//
//  Date+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
    
    func calMidnight() -> Date {
        guard let calDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) else {
            return Date().toString(format: SHDate.date.str()).toDate(format: SHDate.date.str())!
        }
        return calDate
    }
    
    func calNextMidnight() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self.calMidnight())!
    }
}
