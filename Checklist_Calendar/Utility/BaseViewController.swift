//
//  BaseViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        
        dp.locale = NSLocale(localeIdentifier: "ko_KR") as Locale // datePicker의 default 값이 영어이기 때문에 한글로 바꿔줌.
//        dp.locale = NSLocale.current
        dp.timeZone = .autoupdatingCurrent
        // TODO: 글로벌 대응
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure() {
        view.backgroundColor = .bgColor
    }
   
    // TODO: 수정 필요
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
    
    func showDatePickerPopup(mode: UIDatePicker.Mode = .date, okBtnHandler: ((UIAlertAction) -> Void)? = nil) {
        datePicker.datePickerMode = mode
        print(datePicker.locale)
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        let ok = UIAlertAction(title: "선택완료", style: .cancel, handler: okBtnHandler)
        ok.setValue(UIColor.black, forKey: "titleTextColor")
        dateChooserAlert.addAction(ok)
    
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        dateChooserAlert.view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        present(dateChooserAlert, animated: true, completion: nil)
    }
}
