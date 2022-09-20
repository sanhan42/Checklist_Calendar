//
//  WriteViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit
import SwiftUI
import RealmSwift
import Toast

class WriteViewController: BaseViewController {
    let mainView = WriteView()
    let repository = EventRepository()
    var hasChanges = false { // View의 변화를 감지하기 위한 변수
        didSet {
            self.navigationController?.isModalInPresentation = self.hasChanges // 모달 방식으로 dissmiss 못하게 막아줌.
        }
    }
    lazy var writeDate = Date()
    lazy var event = Event(title: "", color: UIColor.cherryColor.toHexString(), date: calMidnight(date: writeDate), startTime: writeDate, endTime: Calendar.current.date(byAdding: .hour, value: 1, to: writeDate) ?? writeDate) {
        didSet {
            hasChanges = true
        }
    }
    
    var todoTableViewCell: TodoTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar()
        print(repository.fileUrl)
    }
    
    override func configure() {
        super.configure()
        view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        navigationController?.presentationController?.delegate = self
    }
    
    private func setNavigationBar() {
        title = "새로운 이벤트"
        let cancleItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleItemClicked))
        cancleItem.tintColor = .cherryColor
        let saveItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(okButtonClicked))
        saveItem.tintColor = .cherryColor.withAlphaComponent(0.9)
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveItem
    }
    
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tag == 1 ? 8 : CGFloat.leastNormalMagnitude
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
                return event.isAllDay ? 90 : 130 // TODO: 수정 필요!
            default: return tableView.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - (event.isAllDay ? 90 : 130) - 70
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
                cell.titleTextField.tag = -2
                cell.titleTextField.delegate = self
                cell.colorButton.selectedColor = UIColor(hexAlpha: event.color)
                cell.colorButton.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
                if event.todos.isEmpty {
                    cell.titleTextField.becomeFirstResponder()
                }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier, for: indexPath) as? DateTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.timeView.isHidden = event.isAllDay
                cell.allDaySwitch.setOn(event.isAllDay, animated: false)
                cell.allDaySwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
                cell.startDateBtn.addTarget(self, action: #selector(setStartDate), for: .touchUpInside)
                cell.endDateBtn.addTarget(self, action: #selector(setEndDate), for: .touchUpInside)
                cell.startTimeBtn.addTarget(self, action: #selector(setStartTime), for: .touchUpInside)
                cell.endTimeBtn.addTarget(self, action: #selector(setEndTime), for: .touchUpInside)
                cell.startDateBtn.setTitle(event.startDate.toString(format: "yy/MM/dd (E)"), for: .normal)
                cell.endDateBtn.setTitle(event.endDate.toString(format: "yy/MM/dd (E)"), for: .normal)
                cell.startTimeBtn.setTitle(event.startTime.toString(format: "a hh:mm"), for: .normal)
                cell.endTimeBtn.setTitle(event.endTime.toString(format: "a hh:mm"), for: .normal)
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
            cell.bgView.layer.borderColor = UIColor.clear.cgColor
            if indexPath.section == 0 && !event.todos.isEmpty {
                cell.textField.tag = indexPath.row
                cell.checkButton.tag = indexPath.row
                cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(sender:)), for: .touchUpInside)
                cell.textField.placeholder = "내용을 입력해주세요"
                cell.textField.text = event.todos[indexPath.row].title
                let img = event.todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
                cell.checkButton.setImage(img, for: .normal)
            } else {
                if !event.todos.isEmpty {
                    cell.textField.becomeFirstResponder()
                }
                cell.textField.delegate = self
                cell.textField.tag = -1
                cell.bgView.layer.borderWidth = 0.5
                cell.bgView.layer.cornerRadius = 12
                cell.bgView.layer.borderColor = UIColor.placeholderText.cgColor
            }
            return cell
        }
    }
}

extension WriteViewController {
    func calMidnight(date: Date) -> Date {
        guard let calDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) else {
            return Date().toString(format: DateForm.date.str()).toDate(format: DateForm.date.str())!
        }
        return calDate
    }
    
    func calNextMidnight(date: Date) -> Date {
        let today = calMidnight(date: date)
        return Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }
    
    @objc func cancleItemClicked() {
        let controller = navigationController?.presentationController ?? UIPresentationController(presentedViewController: self, presenting: nil)
        presentationControllerDidAttemptToDismiss(controller)
    }
    
    @objc func okButtonClicked() {
        guard let titleCell = mainView.tableView.cellForRow(at: [0,0]) as? TitleTableViewCell else { return }
        titleCell.titleTextField.endEditing(true)
        var style = ToastStyle()
        style.messageColor = .cherryColor
        style.titleFont = .systemFont(ofSize: 24, weight: .semibold)
        style.backgroundColor = .GrayColor
        if event.title == "" {
            view.makeToast("제목을 입력해주세요", duration: 0.8, position: .center, style: style)
            return
        } else if event.startTime > event.endTime {
            view.makeToast("이벤트의 시작이 종료보다 늦을 수 없습니다", duration: 1, position: .center, style: style)
            return
        }
        
        if event.isAllDay {
            event.startTime = calMidnight(date: event.startTime)
            event.endTime = calNextMidnight(date: event.endDate)
        }
        
        repository.addItem(item: event)
        dismiss(animated: true)
    }
    
    @objc func colorWellChanged(_ sender: UIColorWell) {
        let color = sender.selectedColor ?? .cherryColor
        event.color = color.toHexString()
        self.hasChanges = true
    }
    
    @objc func checkButtonClicked(sender: UIButton) {
        event.todos[sender.tag].isDone.toggle()
        todoTableViewCell?.checkListTableView.reloadRows(at: [[0, sender.tag]], with: .automatic)
        self.hasChanges = true
    }
    
    @objc func onClickSwitch(_ sender: UISwitch) {
        event.isAllDay = sender.isOn
        mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
        self.hasChanges = true
        if sender.isOn {
            guard let dateCell = mainView.tableView.cellForRow(at: [0, 1]) as? DateTableViewCell else { return }
            guard let start = dateCell.startDateBtn.titleLabel?.text?.toDate(format: DateForm.date.str()) else { return }
            guard let end = dateCell.endDateBtn.titleLabel?.text?.toDate(format: DateForm.date.str()) else { return }
            event.startTime = start
            event.endTime = end
            mainView.tableView.reloadRows(at: [[0, 1]], with: .automatic)
        }
    }
    
    @objc func setStartDate() {
        showDatePickerPopup { _ in
            let date = self.calMidnight(date: self.datePicker.date)
            self.event.startDate = date
            if !self.event.isAllDay {
                self.setStartTime()
            } else {
                self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            }
            self.hasChanges = true
        }
    }
    
    @objc func setEndDate() {
        showDatePickerPopup { _ in
            let date = self.calMidnight(date: self.datePicker.date)
            self.event.endDate = date
            if !self.event.isAllDay {
                self.setEndTime()
            } else {
                self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            }
            self.hasChanges = true
        }
    }
    
    @objc func setStartTime() {
        datePicker.minimumDate = nil
        showDatePickerPopup(mode: .time) { _ in
            let components = Calendar.current.dateComponents([.hour, .minute], from: self.datePicker.date)
            guard let date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: self.event.startDate) else { return }
            self.event.startTime = date
            self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            self.hasChanges = true
        }
    }
    
    @objc func setEndTime() {
        showDatePickerPopup(mode: .time) { _ in
            let components = Calendar.current.dateComponents([.hour, .minute], from: self.datePicker.date)
            guard let date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: self.event.endDate) else { return }
            self.event.endTime = date
            self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            self.hasChanges = true
        }
    }
}

extension WriteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag >= 0 || (textField.tag == -2 && textField.text != "") {
            self.hasChanges = true
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let content = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField.tag == -2 { // 이벤트 제목 입력란
            event.title = content
        }
        
        if 0..<event.todos.count ~= textField.tag {
            event.todos[textField.tag].title = content
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == -2 {
            let content = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            event.title = content
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let content = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField.tag == -1 { // 새로운 TODO 입력란
            let todo = Todo(title: content)
            event.todos.append(todo)
            todoTableViewCell?.checkListTableView.reloadData()
            todoTableViewCell?.checkListTableView.scrollToRow(at: [1, 0], at: .bottom, animated: true)
            self.hasChanges = true
            return true
        } else if textField.tag == -2 { // 이벤트 제목 입력란
            event.title = content
            self.hasChanges = true
            let indexPath: IndexPath = event.todos.isEmpty ? [0, 0] : [1, 0]
            guard let checklistCell = todoTableViewCell?.checkListTableView.cellForRow(at: indexPath) as? CheckListTableViewCell else { return false }
            checklistCell.textField.becomeFirstResponder()
            return true
        }
        
        if 0..<event.todos.count ~= textField.tag {
            event.todos[textField.tag].title = content
        }
        return true
    }
}

extension WriteViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if hasChanges {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "저장 하지 않음", style: .destructive) { _ in
                //Hide keyboard
                self.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
