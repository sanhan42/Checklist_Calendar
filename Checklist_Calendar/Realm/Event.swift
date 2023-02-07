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
   
    @Persisted var startDate: Date  /// 이벤트 시작 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var endDate: Date    /// 이벤트 종료 날짜 => 주의! 시간 부분은 잘못될 수 있음
    @Persisted var startHour: Int   /// 시작 시간이 같은 이벤트들을 묶어줄 떄 사용
    @Persisted var notiOption: Int
    @Persisted var isAllDay: Bool
    @Persisted var todos: List<Todo>
    
    convenience init(title: String, color: String, startDate: Date, endDate: Date, startTime: Date, endTime: Date, isAllDay: Bool = false, notiOption: Int = 0) {
        self.init()
        self.title = title
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = startDate
        self.endDate = endDate
        self.startHour = Calendar.current.dateComponents([.hour], from: startTime).hour!
        self.notiOption = notiOption
        self.isAllDay = isAllDay
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func getOptionName() -> String {
        switch self.notiOption {
        case 0:
            return "없음"
        case 1:
            return "이벤트 당시"
        case 2:
            return "5분 전"
        case 3:
            return "10분 전"
        case 4:
            return "15분 전"
        case 5:
            return "30분 전"
        case 6:
            return "1시간 전"
        case 7:
            return "2시간 전"
        case 8:
            return "1일 전"
        case 9:
            return "2일 전"
        case 10:
            return "1주 전"
        default : return ""
        }
    }
    
    func getNotiDate() -> Date {
        var minute: Int
        switch self.notiOption {
        case 2:
            minute = -5
        case 3:
            minute = -10
        case 4:
            minute = -15
        case 5:
            minute = -30
        case 6:
            minute = -60
        case 7:
           minute = -120
        case 8:
            minute = -60 * 24
        case 9:
            minute = -60 * 24 * 2
        case 10:
            minute = -60 * 24 * 7
        default :minute = 0
        }
        return Calendar.current.date(byAdding: .minute, value: minute, to: self.startTime)!
    }
}
