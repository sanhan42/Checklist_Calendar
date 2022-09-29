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
import UserNotifications

class WriteViewController: BaseViewController {
    let mainView = WriteView()
    private let repository = EventRepository()
    let notificationCenter = UNUserNotificationCenter.current()
    var noPermissions = false
    
    var realmEvent: Event?
    var realmTemplate: Template?
    var isTemplatePage = false
    private var hasChanges = false { // View의 변화를 감지하기 위한 변수
        didSet {
            self.navigationController?.isModalInPresentation = self.hasChanges // 모달 방식으로 dissmiss 못하게 막아줌.
        }
    }
    
    var writeDate = Date()
    
    lazy var event: Event = Event(title: "", color: UIColor.cherryColor.toHexString(), startDate: writeDate.calMidnight(), endDate: writeDate.calMidnight(), startTime: writeDate, endTime: Calendar.current.date(byAdding: .hour, value: 1, to: writeDate) ?? writeDate) {
        didSet {
            hasChanges = true
        }
    }
    
    var todoTableViewCell: TodoTableViewCell?
    var checkListTableViewCell : CheckListTableViewCell?
    
    var afterDissmiss: (() -> ())?
    
    override func loadView() {
        view = mainView
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar()
        setToolbar()
        setEvent()
    }
    
    override func configure() {
        super.configure()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        navigationController?.presentationController?.delegate = self
    }
    
    private func setNavigationBar() {
        let name = isTemplatePage ? "템플릿" : "이벤트"
        let tasks = isTemplatePage ? realmTemplate : realmEvent
        title = tasks == nil ? "새로운 " + name : name + " 세부사항"
        navigationController?.navigationBar.backgroundColor = .tableBgColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        let cancleItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancleItemClicked))
        cancleItem.tintColor = .textColor
        let saveBtnTitle = (realmEvent == nil && realmTemplate == nil) ? "추가" : "편집"
        let saveItem = UIBarButtonItem(title: saveBtnTitle, style: .done, target: self, action: #selector(okButtonClicked))
        saveItem.tintColor = .textColor
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveItem
    }
    
    private func setToolbar() {
        navigationController?.isToolbarHidden = realmEvent == nil
        let btn = UIButton()
        let name = isTemplatePage ? "템플릿" : "이벤트"
        btn.setTitle(name + " 삭제", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16.5, weight: .bold)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(deleteEventBtnClicked), for: .touchUpInside)
        let deleteEventBtn = UIBarButtonItem(customView: btn)
        toolbarItems = [deleteEventBtn]
    }
    
    func setEvent() {
        if realmEvent != nil {
            let temp = realmEvent!
            self.event = Event(title: temp.title, color: temp.color, startDate: temp.startDate, endDate: temp.endDate, startTime: temp.startTime, endTime: temp.endTime, isAllDay: temp.isAllDay, notiOption: temp.notiOption)
            for todo in realmEvent!.todos {
                let new = Todo(title: todo.title, isDone: todo.isDone)
                event.todos.append(new)
            }
            hasChanges = false
        } else if realmTemplate != nil {
            let temp = realmTemplate!
            self.event = Event(title: temp.title, color: temp.color, startDate: writeDate, endDate: writeDate, startTime: temp.startTime, endTime: temp.endTime, isAllDay: temp.isAllDay, notiOption: temp.notiOption)
            for todo in temp.todos {
                let new = Todo(title: todo.title, isDone: todo.isDone)
                self.event.todos.append(new)
            }
            hasChanges = false
            
        }
    }
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 && indexPath.row == 2 {
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error { print(#function, error) }
                
                if !granted {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "알림 권한", message: "알림 설정을 위해선 알림 권한을 허용해주셔야 합니다 :)", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "권한 설정으로 이동", style: .destructive) { _ in
                            if let appSettingUrl = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettingUrl, options: [:], completionHandler: nil)
                            }
                        }
                        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
                        alert.addAction(ok)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hasChanges = true
                        let vc = NotificationViewController()
                        vc.selectedRow = self.event.notiOption
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
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
            let num: CGFloat = isTemplatePage ? 35 : 0
            switch indexPath.row {
            case 0: return 46
            case 1:
                return event.isAllDay ? 76 - num : 106 - num // TODO: 수정 필요!
            case 2: return 38
            default: return tableView.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - (event.isAllDay ? 76 - num : 106 - num) - 70 - 38
            }
        } else {
            return 38
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 4
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
                cell.titleTextField.text = event.title
                cell.textNumLabel.text = "\(event.title.count)/20"
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
                cell.dateView.isHidden = isTemplatePage
                if isTemplatePage {
                    cell.dateView.snp.remakeConstraints { make in
                        make.horizontalEdges.equalToSuperview().inset(10)
                        make.top.equalTo(cell.titleView.snp.bottom).inset(-10)
                        make.height.equalTo(CGFloat.leastNonzeroMagnitude)
                    }
                }
                cell.timeView.isHidden = event.isAllDay
                cell.allDaySwitch.setOn(event.isAllDay, animated: false)
                cell.allDaySwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
                cell.startDateBtn.addTarget(self, action: #selector(setStartDate), for: .touchUpInside)
                cell.endDateBtn.addTarget(self, action: #selector(setEndDate), for: .touchUpInside)
                cell.startTimeBtn.addTarget(self, action: #selector(setStartTime), for: .touchUpInside)
                cell.endTimeBtn.addTarget(self, action: #selector(setEndTime), for: .touchUpInside)
                cell.startDateBtn.setTitle(event.startTime.toString(format: "yy/MM/dd (E)"), for: .normal)
                let endDate = event.isAllDay ? Calendar.current.date(byAdding: .second , value: -1, to: event.endTime)! : event.endTime
                cell.endDateBtn.setTitle(endDate.toString(format: "yy/MM/dd (E)"), for: .normal)
                cell.startTimeBtn.setTitle(event.startTime.toString(format: "a hh:mm"), for: .normal)
                cell.endTimeBtn.setTitle(event.endTime.toString(format: "a hh:mm"), for: .normal)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotiTableViewCell.reuseIdentifier, for: indexPath) as? NotiTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .default
                cell.valueLabel.text = self.event.getOptionName()
                return cell
            case 3:
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
            let selectedView = UIView()
            selectedView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedView
            cell.bgView.layer.borderColor = UIColor.clear.cgColor
            cell.textField.delegate = self
            
            if indexPath.section == 0 && !event.todos.isEmpty {
                cell.textField.tag = indexPath.row
                cell.checkButton.tag = indexPath.row
                cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(sender:)), for: .touchUpInside)
                cell.textField.placeholder = "내용을 입력해주세요"
                cell.textField.attributedText = event.todos[indexPath.row].isDone ? event.todos[indexPath.row].title.strikeThrough() : event.todos[indexPath.row].title.regular()
                let img = event.todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square")?.imageWithColor(color: .textColor.withAlphaComponent(0.5)) : UIImage(systemName: "square")?.imageWithColor(color: .textColor)
                cell.checkButton.setImage(img, for: .normal)
            } else {
                if !event.todos.isEmpty && realmEvent == nil && realmTemplate == nil {
                    cell.textField.becomeFirstResponder()
                }
                cell.checkButton.setImage(UIImage(systemName: "square.dashed"), for: .normal)
                cell.textField.text = nil
                cell.textField.placeholder = "새로운 할 일 추가"
                cell.textField.tag = -1
                cell.bgView.layer.borderWidth = 0.5
                cell.bgView.layer.cornerRadius = 12
                cell.bgView.layer.borderColor = UIColor.placeholderText.cgColor
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView.tag == 0 || indexPath.section == 1 || (event.todos.isEmpty && indexPath.section == 0) { return nil }
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: nil, message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                self.event.todos.remove(at: indexPath.row)
                self.todoTableViewCell?.checkListTableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        
        delete.image = .init(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension WriteViewController {
    @objc func deleteEventBtnClicked() {
        let deleteAlert = UIAlertController(title: nil, message: "이 이벤트를 삭제하겠습니까?", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "이벤트 삭제", style: .destructive) { _ in
            self.repository.deleteEvent(event: self.realmEvent!)
            self.afterDissmiss?()
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        deleteAlert.addAction(ok)
        deleteAlert.addAction(cancel)
        present(deleteAlert, animated: true, completion: nil)
        
    }
    
    @objc func cancleItemClicked() {
        guard let titleCell = mainView.tableView.cellForRow(at: [0,0]) as? TitleTableViewCell else { return }
        titleCell.titleTextField.endEditing(true)
        let controller = navigationController?.presentationController ?? UIPresentationController(presentedViewController: self, presenting: nil)
        presentationControllerDidAttemptToDismiss(controller)
    }
    
    @objc func okButtonClicked() {
        guard let titleCell = mainView.tableView.cellForRow(at: [0,0]) as? TitleTableViewCell else { return }
        titleCell.titleTextField.becomeFirstResponder()
        titleCell.titleTextField.endEditing(true)
        
        if event.isAllDay {
            event.startTime = event.startDate.calMidnight()
            event.endTime = event.endDate.calNextMidnight()
            event.startHour = 0
        }
        
        if event.title == "" {
            view.makeToast("제목을 입력해주세요", duration: 0.8, position: .center)
            return
        } else if (event.startTime > event.endTime) || (event.isAllDay && (event.startDate > event.endDate)) {
            view.makeToast("이벤트의 시작이 종료보다 늦을 수 없습니다", duration: 1, position: .center)
            return
        }
        
        if isTemplatePage {
            let newTemplate = Template(title: event.title, color: event.color, startTime: event.startTime, endTime: event.endTime, isAllDay: event.isAllDay, notiOption: event.notiOption)
            for todo in event.todos {
                newTemplate.todos.append(todo)
            }
            realmTemplate == nil ? repository.addTemplate(template: newTemplate) : repository.updateTemplate(old: realmTemplate!, new: newTemplate)
        } else {
            if self.event.notiOption != 0 {
                self.notificationCenter.getNotificationSettings { settings in
                    guard settings.authorizationStatus == .authorized else {
                        self.noPermissions = true
                        DispatchQueue.main.async {
                            self.repository.updateEventLotiOpt(event: self.event, option: 0)
                        }
                        return
                    }
                    
                    let content = UNMutableNotificationContent()
                    content.title = self.event.title
                    content.subtitle = self.event.notiOption == 1 ? "이벤트 시작 시간입니다!" : "이벤트 시작 " + self.event.getOptionName() + " 입니다."
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.event.getNotiDate())
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: "\(self.event.id)", content: content, trigger: trigger)
                    self.notificationCenter.add(request)
                    }
            }
                self.realmEvent == nil ? self.repository.addEvent(event: self.event) : self.repository.updateEvent(old: self.realmEvent!, new: self.event)
        }
        
        DispatchQueue.main.async {
            if self.noPermissions {
                let alert = UIAlertController(title: "알림 권한 없음", message: "알림 등록에 실패하였습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                    self.afterDissmiss?()
                    self.dismiss(animated: true)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.noPermissions = false
                return
            }
            self.afterDissmiss?()
            self.dismiss(animated: true)
        }
    }
   
    private func setNotification() {
        
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
            guard let start = dateCell.startDateBtn.titleLabel?.text?.toDate(format: SHDate.date.str()) else { return }
            guard let end = dateCell.endDateBtn.titleLabel?.text?.toDate(format: SHDate.date.str()) else { return }
            event.startDate = start
            event.endDate = end
            mainView.tableView.reloadRows(at: [[0, 1]], with: .automatic)
        }
    }
    
    @objc func setStartDate() {
        showDatePickerPopup { _ in
            let date = self.datePicker.date.calMidnight()
            self.event.startDate = date
            if !self.event.isAllDay {
                self.setStartTime() // TODO: 이 방식이 불편하면, 대신 여기에 stardTime을 설정해주는 코드가 들어가야 함.
            } else {
                self.event.startTime = date.calMidnight()
                self.event.startHour = 0
                self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            }
            self.hasChanges = true
        }
    }
    
    @objc func setEndDate() {
        showDatePickerPopup { _ in
            let date = self.datePicker.date.calMidnight()
            self.event.endDate = date
            if !self.event.isAllDay {
                self.setEndTime()
            } else {
                self.event.endTime = date.calNextMidnight()
                self.mainView.tableView.reloadRows(at:[[0,1]], with: .automatic)
            }
            self.hasChanges = true
        }
    }
    
    @objc func setStartTime() {
        showDatePickerPopup(mode: .time) { _ in
            let components = Calendar.current.dateComponents([.hour, .minute], from: self.datePicker.date)
            guard let date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: self.event.startDate) else { return }
            self.event.startTime = date
            self.event.startHour = components.hour!
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let content = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField.tag == -2 {
            event.title = content
        }
        
        if 0..<event.todos.count ~= textField.tag {
            event.todos[textField.tag].title = content
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let content = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField.tag == -1 { // 새로운 TODO 입력란
            if content == "" {
                self.view.makeToast("내용을 입력해주세요", duration: 0.8, position: .center)
                return false
            }
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
            let indexPath: IndexPath = 0..<(event.todos.count - 1) ~= textField.tag ? [0, textField.tag + 1] : [1, 0]
            guard let checklistCell = todoTableViewCell?.checkListTableView.cellForRow(at: indexPath) as? CheckListTableViewCell else { return false }
            checklistCell.textField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == -2 {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let changeText = currentText.replacingCharacters(in: stringRange, with: string)
            guard let cell = mainView.tableView.cellForRow(at: [0, 0]) as? TitleTableViewCell else { return false }
            cell.textNumLabel.text = "\(changeText.count)/20"
            return changeText.count <= 19
        }
        return true
    }
}

extension WriteViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if hasChanges {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "변경 사항 폐기", style: .destructive) { _ in
                self.resignFirstResponder() // 키보드를 숨겨주려고 추가
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "계속 편집하기", style: .cancel, handler: nil)
            cancel.setValue(UIColor.redColor, forKey: "titleTextColor")
            alert.addAction(dismiss)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
