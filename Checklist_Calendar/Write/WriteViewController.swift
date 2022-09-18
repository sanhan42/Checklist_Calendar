//
//  WriteViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class WriteViewController: BaseViewController {
    let mainView = WriteView()
    var isAllDay = false
    var startDate = Date() {
        didSet {
            mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        }
    }
    var endDate = Date()
    var startTime: Date?
    var endTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        super.configure()
        view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 50
        case 1:
            return isAllDay ? 80 : 120 // TODO: 수정 필요!
        default: return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell()}
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier, for: indexPath) as? DateTableViewCell else { return UITableViewCell()}
            cell.timeView.isHidden = cell.allDaySwitch.isOn // TODO: Realm Data 반영하기
            cell.allDaySwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
            cell.startDateBtn.addTarget(self, action: #selector(setStartDate), for: .touchUpInside)
            cell.endDateBtn.addTarget(self, action: #selector(setEndDate), for: .touchUpInside)
            cell.startTimeBtn.addTarget(self, action: #selector(setStartTime), for: .touchUpInside)
            cell.endTimeBtn.addTarget(self, action: #selector(setEndTime), for: .touchUpInside)
            cell.startDateBtn.setTitle(startDate.toString(format: "yy/MM/dd(E)"), for: .normal)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension WriteViewController {
    @objc func onClickSwitch(_ sender: UISwitch) {
        isAllDay = sender.isOn
//        mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        mainView.tableView.reloadData()
//        sender.setOn(sender.isOn, animated: true)
    }
    
    @objc func setStartDate() {
        showDatePickerPopup { _ in
            self.startDate = self.datePicker.date
        }
    }
    
    @objc func setEndDate() {
        showDatePickerPopup { _ in
            self.endDate = self.datePicker.date
        }
    }
    
    @objc func setStartTime() {
        showDatePickerPopup(mode: .time) { _ in
            self.startTime = self.datePicker.date
        }
    }
    
    @objc func setEndTime() {
        showDatePickerPopup(mode: .time) { _ in
            self.endTime = self.datePicker.date
        }
    }
}
