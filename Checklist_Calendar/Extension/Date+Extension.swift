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
//        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier:"ko_KR")
//        dateFormatter.timeZone = TimeZone(identifier: "KST")
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
    
    func getDateStr(needOneLine: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let current = Calendar.current
        if current.isDateInToday(self) {
            dateFormatter.dateFormat = "a hh:mm"
        } else if current.dateComponents([.year], from: self, to: Date()).year! == 0 {
            dateFormatter.dateFormat  = needOneLine ? "(MM월 dd일 a hh:mm)" : "MM월 dd일\n a hh:mm"
        } else {
            dateFormatter.dateFormat = needOneLine ? "(yy년 MM월 dd일 a hh:mm)" : "yyyy년\nMM월 dd일\na hh:mm"
        }
        return dateFormatter.string(from: self)
    }
}
