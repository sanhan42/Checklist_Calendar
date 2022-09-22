//
//  EventRepository.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/19.
//

import Foundation
import RealmSwift

protocol EventRepositoryType {
    func addEvent(event: Event)
    func dayTasksFetch(date: Date) -> Results<Event>
    func allDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event>
    func notAllDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event>
    func updateEvent(old: Event, new: Event)
    func deleteEvent(event: Event)
    
    func deleteTodo(todo: Todo)
    func updateTodoTitle(todo: Todo, title: String)
    func updateTodoStatus(todo: Todo)
}

class EventRepository: EventRepositoryType {
    let fileUrl = Realm.Configuration.defaultConfiguration.fileURL!
    let localRealm = try! Realm()
    
    func addEvent(event: Event) {
        do {
            try localRealm.write({
                localRealm.add(event)
            })
        } catch let error {
            print(error)
        }
    }
    
    func dayTasksFetch(date: Date) -> Results<Event> {
        let todayStart = date.calMidnight()
        let todayEnd = date.calNextMidnight()
        return localRealm.objects(Event.self).where {
            ($0.start <= todayEnd && $0.endTime > todayStart)
        }
    }
    
    func allDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event> {
        let todayStart = date.calMidnight()
        let todayEnd = date.calNextMidnight()
        if isHiding {
            return localRealm.objects(Event.self).sorted(byKeyPath: "endTime", ascending: true).where {
                $0.endTime > Date() && ($0.startTime <= todayStart && $0.endTime >= todayEnd)
            }
        } else {
            return localRealm.objects(Event.self).sorted(byKeyPath: "endTime", ascending: true).where {
                ($0.startTime <= todayStart && $0.endTime >= todayEnd)
            }
        }
        
    }
    
    func notAllDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event> {
        let todayStart = date.calMidnight()
        let todayEnd = date.calNextMidnight()
        let todayEventTasks = dayTasksFetch(date: date)
        if isHiding {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                $0.endTime > Date() && (($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd))
            }
        } else {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                ($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd)
            }
        }
    }
    
    func updateEvent(old: Event, new: Event) {
        deleteEvent(event: old)
        addEvent(event: new)
    }
    
    func deleteEvent(event: Event) {
        deleteTodos(todos: event.todos)
        do {
            try localRealm.write({
                localRealm.delete(event)
            })
        } catch let error {
            print(error)
        }
    }
    
    func deleteTodos(todos: List<Todo>) {
        do {
            try localRealm.write({
                localRealm.delete(todos)
            })
        } catch let error {
            print(error)
        }
    }
    
    func deleteTodo(todo: Todo) {
        do {
            try localRealm.write({
                localRealm.delete(todo)
            })
        } catch let error {
            print(error)
        }
    }

    func updateTodoTitle(todo: Todo, title: String) {
        do {
            try localRealm.write({
                todo.title = title
            })
        } catch let error {
            print(error)
        }
    }
    
    func updateTodoStatus(todo: Todo) {
        do {
            try localRealm.write({
                todo.isDone.toggle()
            })
        } catch let error {
            print(error)
        }
    }
}
