//
//  DateFormEnum.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/19.
//

import Foundation

enum DateForm {
    case date
    case time
    
    func str() -> String {
        switch self {
        case .date: return "yy/MM/dd (E)"
        case .time: return "a hh:mm"
        }
    }

}

