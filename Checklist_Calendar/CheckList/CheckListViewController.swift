//
//  CheckListViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/22.
//

import UIKit
import RealmSwift
import SwiftUI

class CheckListViewController: BaseViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.register(CheckListTableCell.self, forCellReuseIdentifier: CheckListTableCell.reuseIdentifier)
        view.sectionHeaderHeight = 38
        return view
    }()
    
    let repository = EventRepository()
    
    var allDayTasks: Results<Event>!
    var notAllDayTasks: Results<Event>!
    var selectedDate: Date!
    var afterDissmiss: (() -> ())?
    var isHiding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        super.configure()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.presentationController?.delegate = self
        setTitleBtn()
        setNavigationLeftItems()
    }
    
    func setTitleBtn() {
        let titleBtn: UIView = {
            let bgView = UIView()
            let btn = UIButton()
            btn.setTitle(selectedDate.toString(format: selectedDate.toString(format: " yy년 MM월 dd일 (E)")), for: .normal)
            btn.setImage(UIImage(systemName: "calendar"), for: .normal)
            btn.tintColor = .textColor
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(.textColor, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            btn.contentHorizontalAlignment = .center
            btn.semanticContentAttribute = .forceLeftToRight
            btn.imageEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 18)
            btn.addTarget(self, action: #selector(calendarBtnClicked), for: .touchUpInside)
            bgView.addSubview(btn)
            bgView.snp.makeConstraints { make in
                make.width.equalTo(220)
                make.height.equalTo(28)
            }
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return bgView
        }()
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: titleBtn)
    }
    
    func setNavigationLeftItems() {
       
        let todayBtn: UIView = {
            let bgView = UIView()
            let btn = UIButton()
            btn.setTitle("오늘 ", for: .normal)
            btn.setImage(UIImage(named: "cherry"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(.textColor, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            btn.contentHorizontalAlignment = .center
            btn.semanticContentAttribute = .forceRightToLeft
            btn.imageEdgeInsets = .init(top: 6, left: 18, bottom: 8, right: 18)
            btn.addTarget(self, action: #selector(moveToToday), for: .touchUpInside)
            bgView.layer.borderColor = UIColor.textColor.withAlphaComponent(0.65).cgColor
            bgView.layer.borderWidth = 2
            bgView.layer.cornerRadius = 12
            bgView.addSubview(btn)
            bgView.snp.makeConstraints { make in
                make.width.equalTo(42)
                make.height.equalTo(27)
            }
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return bgView
        }()
        
        let hideBtn: UIButton = {
            let btn = UIButton()
            btn.setTitleColor(UIColor.textColor.withAlphaComponent(0.8), for: .normal)
            btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.65).cgColor
            btn.layer.borderWidth = 2
            btn.layer.cornerRadius = 12
            btn.addTarget(self, action: #selector(hideBtnClicked), for: .touchUpInside)
            btn.snp.makeConstraints { make in
                make.width.equalTo(94)
            }
            let title = isHiding ? "모든 일정 보기" : "지난 일정 숨기기"
            btn.setTitle(title, for: .normal)
            return btn
        }()
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(customView: hideBtn), UIBarButtonItem(customView: todayBtn)]
    }
}

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
        let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
        return tasks[section].todos[indexPath.row].title.heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 15)) + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CheckListHeaderView()
        let tasks: Results<Event> = allDayTasks.isEmpty || section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let index = allDayTasks.isEmpty || section < allDayTasks.count ? section : section - allDayTasks.count
        header.lineView.backgroundColor = UIColor(hexAlpha: tasks[index].color)
        header.titleLabel.text = tasks[index].title
        header.fullDateLabel.text = tasks[index].startTime.getDateStr(needOneLine: true) + " -> " + tasks[index].endTime.getDateStr(needOneLine: true)
        header.tag = section
        header.addButton.addTarget(self, action: #selector(addBtnClicked(_:)), for: .touchUpInside)
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDayTasks.count + notAllDayTasks.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDayTasks.isEmpty {
            return notAllDayTasks[section].todos.count
        }
        
        switch section {
        case 0..<allDayTasks.count:
            return allDayTasks[section].todos.count
        default :
            return notAllDayTasks[section - allDayTasks.count].todos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if allDayTasks.isEmpty && notAllDayTasks.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else { return UITableViewCell() }
            cell.label.text = "먼저 이벤트를 등록해주세요 :)"
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckListTableCell.reuseIdentifier, for: indexPath) as? CheckListTableCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.checkButton.snp.remakeConstraints { make in
            make.width.height.equalTo(15)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        let tagNum = setTagNum(section: indexPath.section, row: indexPath.row)
        let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
        let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
        cell.textView.font = .systemFont(ofSize: 15)
        cell.textView.text = tasks[section].todos[indexPath.row].title
        cell.textView.tag = tagNum
        cell.textView.delegate = self
        let img = tasks[section].todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        cell.checkButton.setImage(img, for: .normal)
        cell.checkButton.tintColor = .textColor.withAlphaComponent(0.9)
        cell.checkButton.tag = tagNum
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: nil, message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "확인", style: .destructive) { [self] _ in
                let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
                let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
                let todos = tasks[section].todos
                repository.deleteTodo(todo: todos[indexPath.row])
                tableView.reloadSections([indexPath.section], with: .none)
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

extension CheckListViewController {
    @objc func hideBtnClicked() {
        isHiding.toggle()
        fetchRealm(isHiding: isHiding)
        setNavigationLeftItems()
        tableView.reloadData()
    }

    @objc func calendarBtnClicked() {
        showDatePickerPopup(mode: .date) { [self] _ in
            selectedDate = datePicker.date
            setTitleBtn()
            fetchRealm(isHiding: isHiding)
            tableView.reloadData()
        }
    }
    
    @objc func moveToToday() {
        selectedDate = Date()
        datePicker.date = selectedDate
        setTitleBtn()
        fetchRealm(isHiding: isHiding)
        tableView.reloadData()
    }
    
    @objc func addBtnClicked(_ sender: UIButton) {
        let section = sender.tag
        let tasks: Results<Event> = allDayTasks.isEmpty || section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let index = allDayTasks.isEmpty || section < allDayTasks.count ? section : section - allDayTasks.count
        repository.addTodoInEvent(event: tasks[index])
        fetchRealm()
        tableView.reloadSections([section], with: .none)
        guard let cell = tableView.cellForRow(at: [section, tasks[index].todos.count - 1]) as? CheckListTableCell else { return }
        cell.textView.becomeFirstResponder()
    }
    
    func fetchRealm(isHiding: Bool = false) {
        allDayTasks = repository.allDayTasksFetch(date: selectedDate, isHiding: isHiding)
        notAllDayTasks = repository.notAllDayTasksFetch(date: selectedDate, isHiding: isHiding)
    }
    
    func setTagNum(section: Int, row: Int) -> Int {
        return section * 100 + row // TODO: 암묵적으로 todo는 한 이벤트당 99개까지만 등록할 수 있는 걸로 정함. => 나중에 todo 추가 부분에 제약 추가해줘야 함.
    }
    
    func calIndexPath(tagNum: Int) -> IndexPath {
         return IndexPath(row: tagNum%100, section: tagNum/100)
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {
        let indexPath = calIndexPath(tagNum: sender.tag)
        let tasks: Results<Event> = allDayTasks.isEmpty || indexPath.section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let section = allDayTasks.isEmpty || indexPath.section < allDayTasks.count ? indexPath.section : indexPath.section - allDayTasks.count
        let row = indexPath.row
        repository.updateTodoStatus(todo: tasks[section].todos[row])
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension CheckListViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let indexPath = calIndexPath(tagNum: textView.tag)
        let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
        let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
        repository.updateTodoTitle(todo: tasks[section].todos[indexPath.row], title: textView.text)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension CheckListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        afterDissmiss?()
    }
}
