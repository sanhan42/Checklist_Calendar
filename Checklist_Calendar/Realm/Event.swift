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
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todos: List<Todo>
    
    convenience init(title: String, color: String, date:Date, startTime: Date, endTime: Date, isAllDay: Bool = false) {
        self.init()
        self.title = title
        self.color = color
        self.startDate = date
        self.startTime = startTime
        self.endDate = date
        self.endTime = endTime
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
