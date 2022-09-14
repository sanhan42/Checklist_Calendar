//
//  Date+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
}
