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
    
    convenience init(title: String, color: String, startDate: Date, endDate:Date, isAllDay: Bool = false) {
        self.init()
        self.title = title
        self.color = color
        self.startDate = startDate
        self.startTime = startDate
        self.endDate = endDate
        self.endTime = endDate
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
