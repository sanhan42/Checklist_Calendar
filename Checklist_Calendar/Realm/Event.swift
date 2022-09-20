//
//  Event.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/15.
//

import Foundation
import RealmSwift

class Event: Object {
    @Persisted var title: String
    @Persisted var color: String
    @Persisted var startDate: Date
    @Persisted var startTime: Date
    @Persisted var endDate: Date
    @Persisted var endTime: Date
    @Persisted var isAllDay: Bool
    @Persisted var start: Date
    @Persisted var end: Date
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todos: List<Todo>
    
    convenience init(title: String, color: String, start:Date, end: Date, startTime: Date, endTime: Date, isAllDay: Bool = false) {
        self.init()
        let interval = Calendar.current.dateComponents([.day], from: startTime, to: endTime)
        let endDate = Calendar.current.date(byAdding: interval, to: start) ?? start
        self.title = title
        self.color = color
        self.startDate = start
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
        self.isAllDay = isAllDay
        self.start = start
        self.end = end
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
