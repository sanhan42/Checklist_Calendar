//
//  MonthlyViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import FSCalendar

class MonthlyViewController: BaseViewController {

    let mainView = MonthlyView()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.mainView.calendar, action: #selector(self.mainView.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        self.view = mainView
        mainView.calendar.dataSource = self
        mainView.calendar.delegate = self

        mainView.titleButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        
        mainView.addGestureRecognizer(scopeGesture)
        mainView.tableView.panGestureRecognizer.require(toFail: scopeGesture)
    }
    
  
    
    @objc func showDatePicker() {
        setDatePickerPopup { _ in
            self.mainView.titleButton.setTitle(self.datePicker.date.toString(), for: .normal)
            self.mainView.calendar.select(self.datePicker.date, scrollToDate: true)
        }
    }
}

extension MonthlyViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.mainView.tableView.contentOffset.y <= -self.mainView.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.mainView.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }
}

extension MonthlyViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        mainView.titleButton.setTitle(mainView.calendar.currentPage.toString(), for: .normal)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        mainView.calendar.removeConstraint(mainView.calendar.constraints.last!)
        mainView.calendar.snp.remakeConstraints { make in
            make.top.equalTo(mainView.calHeaderView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(bounds.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            // TODO: layoutIfNeeded 메서드 검색
        }
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//    }
//  
}
