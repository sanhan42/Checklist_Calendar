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
    
    // start <= startTime <= 이벤트 기간 < endTime <= end
    @Persisted var start: Date      /// 이벤트 시작일 00:00
    @Persisted var startTime: Date  /// 이벤트 실제 시작 날짜, 시간
    @Persisted var endTime: Date    /// 이벤트 실제 종료 날짜, 시간
    @Persisted var end: Date        /// 이벤트 종료일 24:00 = 이벤트 다음날 00:00
    ///
    // startDate 와 endDate는 이벤트 시작일과 종료일의 날짜의 텍스트가 필요할 떄 사용.
    @Persisted var startDate: Date  /// 이벤트 시작 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var endDate: Date    /// 이벤트 종료 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var startHour: Int   /// 시작 시간이 같은 이벤트들을 묶어줄 떄 사용
    @Persisted var isAllDay: Bool
    @Persisted var todos: List<Todo>
    
    convenience init(title: String, color: String, start:Date, end: Date, startTime: Date, endTime: Date, isAllDay: Bool = false) {
        self.init()
        let interval = Calendar.current.dateComponents([.day], from: startTime, to: endTime)
        let endDate = Calendar.current.date(byAdding: interval, to: start) ?? start
        self.title = title
        self.color = color
        self.start = start
        self.startTime = startTime
        self.endTime = endTime
        self.end = end
        self.startDate = start
        self.endDate = endDate
        self.startHour = Calendar.current.dateComponents([.hour], from: startTime).hour!
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
