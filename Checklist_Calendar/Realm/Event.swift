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
    @Persisted var startDate: String
    @Persisted var startTime: String?
    @Persisted var endDate: String
    @Persisted var endTime: String?
    @Persisted var isAllDay: Bool
    @Persisted(primaryKey: true) var id: ObjectId
    let todos = List<Todo>()
    
    convenience init(title: String, color: String, startDate: String, starTime: String?, endDate: String, endTime: String?, isAllDay: Bool) {
        self.init()
        self.title = title
        self.color = color
        self.startDate = startDate
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
