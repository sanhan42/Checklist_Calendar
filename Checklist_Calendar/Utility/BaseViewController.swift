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
        
        dp.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // datePicker의 default 값이 영어이기 때문에 한글로 바꿔줘야한다.
        // TODO: 글로벌 대응
        return dp
    }()
    
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
    
    func setDatePickerPopup(okBtnHandler: ((UIAlertAction) -> Void)? = nil) {
       
        
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        let ok = UIAlertAction(title: "선택완료", style: .cancel, handler: okBtnHandler)
        ok.setValue(UIColor.black, forKey: "titleTextColor")
        dateChooserAlert.addAction(ok)
    
        dateChooserAlert.view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        present(dateChooserAlert, animated: true, completion: nil)
    }
}
