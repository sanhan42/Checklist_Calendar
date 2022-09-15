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
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var isAllDay: Bool
    @Persisted(primaryKey: true) var id: ObjectId
    let todos = List<Todo>()
    
    convenience init(title: String, startDate: Date?, endDate: Date?, isAllDay: Bool) {
        self.init()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
