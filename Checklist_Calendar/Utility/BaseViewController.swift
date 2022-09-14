//
//  BaseViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {}
    
    func setNavi() {}
    
    func getDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let current = Calendar.current
        if current.isDateInToday(date) {
            dateFormatter.dateFormat = "a hh:mm"
        } else if current.isDateInWeekend(date){
            dateFormatter.dateFormat  = "EEEE"
        } else {
            dateFormatter.dateFormat = "yyyy. MM. dd a hh:mm"
        }
        return dateFormatter.string(from: date)
    }
}
