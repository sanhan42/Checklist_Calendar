//
//  Date+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        guard let langCode = Locale.preferredLanguages.first else {
            return dateFormatter.string(from: self)
        }
        if #available(iOS 16, *) {
            guard let regionCode = Locale.current.language.region?.identifier else {
                return dateFormatter.string(from: self)
            }
            dateFormatter.locale = Locale(identifier: langCode + "_" + regionCode)
        } else {
            guard let regionCode = Locale.current.regionCode else {
                return dateFormatter.string(from: self)
            }
            dateFormatter.locale = Locale(identifier: langCode + "_" + regionCode)
        }
        dateFormatter.timeZone = TimeZone.current
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
    
    
    func getDateStr(day: Date, needOneLine: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let current = Calendar.current
        if current.isDate(self, inSameDayAs: day) {
            dateFormatter.dateFormat = "a hh:mm"
        } else if current.dateComponents([.year], from: self, to: Date()).year! == 0 {
            dateFormatter.dateFormat  = needOneLine ? "(MM월 dd일 a hh:mm)" : "MM월 dd일\n a hh:mm"
        } else {
            dateFormatter.dateFormat = needOneLine ? "(yy년 MM월 dd일 a hh:mm)" : "yyyy년\nMM월 dd일\na hh:mm"
        }
        return dateFormatter.string(from: self)
    }
}
