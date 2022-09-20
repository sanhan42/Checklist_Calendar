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
    func tasksFetch(date: Date) -> Results<Event>
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
    
    func tasksFetch(date: Date) -> Results<Event> {
        return localRealm.objects(Event.self).where {
            ($0.startDate <= date && $0.endDate >= date)
        }
    }
}
