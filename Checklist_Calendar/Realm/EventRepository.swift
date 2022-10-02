//
//  EventRepository.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/19.
//

import Foundation
import RealmSwift
import UserNotifications

protocol EventRepositoryType {
    func addEvent(event: Event)
    
    func dayTasksFetch(date: Date) -> Results<Event>
    func allDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event>
    func notAllDayTasksFetch(date: Date, isHiding: Bool) -> Results<Event>
    func atTimeTasksFetch(date: Date, isHiding: Bool, startHour: Int) -> Results<Event>
    
    func updateEvent(old: Event, new: Event)
    func deleteEvent(event: Event)
    
    func addTodoInEvent(event: Event)
    func deleteTodo(todo: Todo)
    func updateTodoTitle(todo: Todo, title: String)
    func updateTodoStatus(todo: Todo)
    
    func templateTasksFetch() -> Results<Template>
    func addTemplate(template: Template)
    func updateTemplate(old: Template, new: Template)
    func deleteTemplate(template: Template)
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
            ($0.startTime < todayEnd && $0.endTime > todayStart)
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
        let date = Calendar.current.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
        if isHiding {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                $0.endTime > date && (($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd))
            }
        } else {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                ($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd)
            }
        }
    }
    
    func atTimeTasksFetch(date: Date, isHiding: Bool, startHour: Int) -> Results<Event> {
        let todayStart = date.calMidnight()
        let todayEnd = date.calNextMidnight()
        let todayEventTasks = dayTasksFetch(date: date)
        let date = Calendar.current.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
        if isHiding {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                $0.endTime > date && (($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd))
            }.where { $0.startHour == startHour }
        } else {
            return todayEventTasks.sorted(byKeyPath: "endTime", ascending: true).sorted(byKeyPath: "startTime", ascending: true).where {
                ($0.startTime <= todayStart && $0.endTime < todayEnd) || ($0.startTime > todayStart && $0.startTime < todayEnd)
            }.where { $0.startHour == startHour }
        }
    }
    
    func updateEvent(old: Event, new: Event) {
        deleteEvent(event: old)
        addEvent(event: new)
    }
    
    func deleteEvent(event: Event) {
        deleteTodos(todos: event.todos)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(event.id)"])
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
    
    func addTodoInEvent(event: Event) {
        do {
            try localRealm.write({
                event.todos.append(Todo())
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
    
    func templateTasksFetch() -> Results<Template> {
        return localRealm.objects(Template.self).sorted(byKeyPath: "startHour", ascending: false)
    }
    
    func addTemplate(template: Template) {
        do {
            try localRealm.write({
                localRealm.add(template)
            })
        } catch let error {
            print(error)
        }
    }
    
    func updateTemplate(old: Template, new: Template) {
        deleteTemplate(template: old)
        addTemplate(template: new)
    }
    
    func deleteTemplate(template: Template) {
        deleteTodos(todos: template.todos)
        do {
            try localRealm.write({
                localRealm.delete(template)
            })
        } catch let error {
            print(error)
        }
    }
    
    func updateEventLotiOpt(event: Event, option: Int) {
        do {
            try localRealm.write({
                event.notiOption = option
            })
        } catch let error {
            print(error)
        }
    }
}
