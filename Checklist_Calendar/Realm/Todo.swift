//
//  Todo.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/15.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted var title: String?
    @Persisted var isDone: Bool
    @Persisted(primaryKey: true) var id: ObjectId
    let forEvent = LinkingObjects(fromType: Event.self, property: "todos")
   
    convenience init(title: String?) {
        self.init()
        self.title = title
        self.isDone = false
    }
}

