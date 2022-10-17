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
        dp.maximumDate = "2099.12.31 오후 11:59:59".toDate(format: "yyyy.MM.dd a hh:mm:ss")
        dp.minimumDate = "1970.01.01 오전 00:00:00".toDate(format: "yyyy.MM.dd a hh:mm:ss")
        
        dp.locale = Locale.current
        guard let langCode = Locale.preferredLanguages.first else { return dp }
        
        if #available(iOS 16, *) {
            guard let regionCode = Locale.current.language.region?.identifier else { return dp }
            dp.locale = Locale(identifier: langCode + "_" + regionCode)
        } else {
            guard let regionCode = Locale.current.regionCode else { return dp }
            dp.locale = Locale(identifier: langCode + "_" + regionCode)
        }
        dp.timeZone = .autoupdatingCurrent
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure() {
        view.backgroundColor = .bgColor
    }
    
    func showDatePickerPopup(mode: UIDatePicker.Mode = .date, okBtnHandler: ((UIAlertAction) -> Void)? = nil) {
        datePicker.datePickerMode = mode
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        let ok = UIAlertAction(title: "선택완료", style: .cancel, handler: okBtnHandler)
        ok.setValue(UIColor.textColor, forKey: "titleTextColor")
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
