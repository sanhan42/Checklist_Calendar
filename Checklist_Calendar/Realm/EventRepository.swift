//
//  EventRepository.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/19.
//

import Foundation
import RealmSwift

protocol EventRepositoryType {
    func addItem(item: Event)
    func dayTasksFetch(date: Date) -> Results<Event>
    func allDayTasksFetch(date: Date) -> Results<Event>
    func notAllDayTasksFetch(date: Date) -> Results<Event>
}

class EventRepository: EventRepositoryType {
    let fileUrl = Realm.Configuration.defaultConfiguration.fileURL!
    let localRealm = try! Realm()
    
    func addItem(item: Event) {
        do {
            try localRealm.write({
                localRealm.add(item)
            })
        } catch let error {
            print(error)
        }
    }
    
    func dayTasksFetch(date: Date) -> Results<Event> {
        return localRealm.objects(Event.self).where {
            ($0.start <= date && $0.end > date)
        }
    }
    
    func allDayTasksFetch(date: Date) -> Results<Event> {
        let todayStart = date.calMidnight() // 만약 매개변수 값으로 들어오는 Date가 00시 00분의 형태로 들어온다면 이 작업은 필요 없음.
        let todayEnd = date.calNextMidnight()
        return localRealm.objects(Event.self).where {
            ($0.startTime <= todayStart && $0.endTime >= todayEnd)
        }
    }
    
    func notAllDayTasksFetch(date: Date) -> Results<Event> {
        let todayStart = date.calMidnight()
        return localRealm.objects(Event.self).where {
            ($0.start <= date && $0.end > date && $0.startTime > todayStart)
        }
    }
    
   
    
}
