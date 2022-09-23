//
//  Event.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/15.
//

import Foundation
import RealmSwift

class Event: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var color: String
    
    @Persisted var startTime: Date  /// 이벤트 실제 시작 날짜, 시간
    @Persisted var endTime: Date    /// 이벤트 실제 종료 날짜, 시간
    ///
    @Persisted var startDate: Date  /// 이벤트 시작 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var endDate: Date    /// 이벤트 종료 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var startHour: Int   /// 시작 시간이 같은 이벤트들을 묶어줄 떄 사용
    @Persisted var isAllDay: Bool
    @Persisted var isTemplate: Bool
    @Persisted var todos: List<Todo>
    
    convenience init(title: String, color: String, startDate: Date, endDate: Date, startTime: Date, endTime: Date, isAllDay: Bool = false, isTemplate: Bool = false) {
        self.init()
        self.title = title
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = startDate
        self.endDate = endDate
        self.startHour = Calendar.current.dateComponents([.hour], from: startTime).hour!
        self.isAllDay = isAllDay
        self.isTemplate = isTemplate
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
