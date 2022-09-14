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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestureRecognizer()
        configure()
        // Do any additional setup after loading the view.
    }
    
    override func configure() {
        self.view = mainView
        mainView.calendar.dataSource = self
        mainView.calendar.delegate = self

        mainView.titleButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    func addSwipeGestureRecognizer() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        mainView.calendar.scope = swipe.direction == .up ? .week : .month
//        let height = swipe.direction == .up ? 80 : 300
//        mainView.calendar.snp.makeConstraints {[height] make in
//            make.height.equalTo(height)
//        }
    }
    
    @objc func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // datePicker의 default 값이 영어이기 때문에 한글로 바꿔줘야한다.
        // TODO: 글로벌 대응
        
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        let ok = UIAlertAction(title: "선택완료", style: .cancel, handler: { _ in
            self.mainView.titleButton.setTitle(datePicker.date.toString(), for: .normal)
            self.mainView.calendar.select(datePicker.date, scrollToDate: true)
        })
        ok.setValue(UIColor.black, forKey: "titleTextColor")
        dateChooserAlert.addAction(ok)
        
//        let height : NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
//        dateChooserAlert.view.addConstraint(height)
        dateChooserAlert.view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
       present(dateChooserAlert, animated: true, completion: nil)
    }
}

extension MonthlyViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        mainView.titleButton.setTitle(mainView.calendar.currentPage.toString(), for: .normal)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendar.removeConstraint(mainView.calendar.constraints.last!)
        mainView.calendar.snp.makeConstraints { make in
            make.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
