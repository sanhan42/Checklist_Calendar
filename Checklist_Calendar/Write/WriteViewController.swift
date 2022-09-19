//
//  WriteViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit
import SwiftUI

class WriteViewController: BaseViewController {
    let mainView = WriteView()
    var isAllDay = false
    var event = Event(title: "", color: "", startDate: Date(), starTime: nil, endDate: Date(), endTime: nil, isAllDay: false)
    var newTodo = ""
    
    lazy var startDate = datePicker.date {
        didSet {
            mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        }
    }
    lazy var endDate = datePicker.date {
        didSet {
            mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        }
    }
    var startTime = Date() {
        didSet {
            mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        }
    }
    var endTime = Date() {
        didSet {
            mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        }
    }
    
    var todoTableViewCell: TodoTableViewCell?
    //            guard let cell = todoTableViewCell?.checkListTableView.cellForRow(at: [0, textField.tag]) as? CheckListTableViewCell else { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar()
    }
    
    override func configure() {
        super.configure()
        view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    @objc func cancleItemClicked() {
        dismiss(animated: true)
    }
    
    private func setNavigationBar() {
        title = "새로운 이벤트"
        let cancleItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleItemClicked))
        cancleItem.tintColor = .cherryColor
        let okItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: nil)
        okItem.tintColor = .cherryColor.withAlphaComponent(0.9)
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = okItem
    }
    
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        return headerView
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag != 0 && !event.todos.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            switch indexPath.row {
            case 0: return 50
            case 1:
                return isAllDay ? 90 : 130 // TODO: 수정 필요!
            default: return tableView.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - (isAllDay ? 90 : 130) - 70
            }
        } else {
            return 38
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 3
        } else{
            switch section {
            case 0: return event.todos.count == 0 ? 1 : event.todos.count
            default : return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier, for: indexPath) as? DateTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.timeView.isHidden = isAllDay // cell.allDaySwitch.isOn // TODO: Realm Data 반영하기
                cell.allDaySwitch.setOn(isAllDay, animated: false)
                cell.allDaySwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
                cell.startDateBtn.addTarget(self, action: #selector(setStartDate), for: .touchUpInside)
                cell.endDateBtn.addTarget(self, action: #selector(setEndDate), for: .touchUpInside)
                cell.startTimeBtn.addTarget(self, action: #selector(setStartTime), for: .touchUpInside)
                cell.endTimeBtn.addTarget(self, action: #selector(setEndTime), for: .touchUpInside)
                cell.startDateBtn.setTitle(startDate.toString(format: "yy/MM/dd (E)"), for: .normal)
                cell.endDateBtn.setTitle(endDate.toString(format: "yy/MM/dd (E)"), for: .normal)
                cell.startTimeBtn.setTitle(startTime.toString(format: "a hh:mm"), for: .normal)
                cell.endTimeBtn.setTitle(endTime.toString(format: "a hh:mm"), for: .normal)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as? TodoTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.checkListTableView.delegate = self
                cell.checkListTableView.dataSource = self
                todoTableViewCell = cell
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckListTableViewCell.reuseIdentifier, for: indexPath) as? CheckListTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            if indexPath.section == 0 && !event.todos.isEmpty {
                cell.textField.tag = indexPath.row
                cell.checkButton.tag = indexPath.row
                cell.textField.text = event.todos[indexPath.row].title
                let img = event.todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
                cell.checkButton.setImage(img, for: .normal)
            } else {
                cell.textField.delegate = self
                cell.textField.tag = -1
                cell.contentView.layer.borderWidth = 0.3
                cell.contentView.layer.borderColor = UIColor.placeholderText.cgColor
            }
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.tag == 1 && !event.todos.isEmpty {
//            guard let cell = tableView.cellForRow(at: [0, indexPath.row]) as? CheckListTableViewCell else { return }
//            cell.textField.tag = indexPath.row
//        }
//    }
}

extension WriteViewController {
    @objc func onClickSwitch(_ sender: UISwitch) {
        isAllDay = sender.isOn
        mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
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
        datePicker.minimumDate = nil
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

extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let todoTablecell = mainView.tableView.cellForRow(at: [0, 2]) as? TodoTableViewCell else { return false }
        if textField.tag == -1 { // 새로운 TODO 입력란
            let todo = Todo(title: textField.text)
            event.todos.append(todo)
            todoTableViewCell?.checkListTableView.reloadData()
            return true
        }
        
        if 0..<event.todos.count ~= textField.tag {
            event.todos[textField.tag].title = textField.text
        }
        return true
    }
}
