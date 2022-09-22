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
        view.register(CheckListTableViewCell.self, forCellReuseIdentifier: CheckListTableViewCell.reuseIdentifier)
        return view
    }()
    
    let repository = EventRepository()
    
    var allDayTasks: Results<Event>!
    var notAllDayTasks: Results<Event>!
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = selectedDate.toString(format: "yy년 MM월 dd일 (E)")
    }
    
    override func configure() {
        super.configure()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CheckListHeaderView()
        let tasks: Results<Event> = allDayTasks.isEmpty || section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let index = allDayTasks.isEmpty || section < allDayTasks.count ? section : section - allDayTasks.count
        header.lineView.backgroundColor = UIColor(hexAlpha: tasks[index].color)
        header.titleLabel.text = tasks[index].title
        header.fullDateLabel.text = tasks[index].startTime.getDateStr(needOneLine: true) + " -> " + tasks[index].endTime.getDateStr(needOneLine: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckListTableViewCell.reuseIdentifier, for: indexPath) as? CheckListTableViewCell else { return UITableViewCell() }
//        if allDayTasks.isEmpty {
//            cell.textField.text = notAllDayTasks[indexPath.section].todos[indexPath.row].title
//            return cell
//        }
        
        let tagNum = setTagNum(section: indexPath.section, row: indexPath.row)
        let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
        let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
        cell.textField.text = tasks[section].todos[indexPath.row].title
        cell.textField.tag = tagNum
        cell.textField.addTarget(self, action: #selector(todoTitleChanged(_:)), for: .editingChanged)
        let img = tasks[section].todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        cell.checkButton.setImage(img, for: .normal)
        cell.checkButton.tag = tagNum
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
}

extension CheckListViewController {
    func setTagNum(section: Int, row: Int) -> Int {
        return section * 100 + row // TODO: 암묵적으로 todo는 한 이벤트당 99개까지만 등록할 수 있는 걸로 정함. => 나중에 todo 추가 부분에 제약 추가해줘야 함.
    }
    
    func calIndexPath(tagNum: Int) -> IndexPath {
         return IndexPath(row: tagNum%100, section: tagNum/100)
    }
   
    @objc func todoTitleChanged(_ sender: UITextField) {
        let indexPath = calIndexPath(tagNum: sender.tag)
        let tasks: Results<Event> = allDayTasks.isEmpty || indexPath.section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let section = allDayTasks.isEmpty || indexPath.section < allDayTasks.count ? indexPath.section : indexPath.section - allDayTasks.count
        let row = indexPath.row
        repository.updateTodoTitle(todo: tasks[section].todos[row], title: sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        tableView.reloadRows(at: [indexPath], with: .automatic)
        sender.becomeFirstResponder()
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {
        let indexPath = calIndexPath(tagNum: sender.tag)
        let tasks: Results<Event> = allDayTasks.isEmpty || indexPath.section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let section = allDayTasks.isEmpty || indexPath.section < allDayTasks.count ? indexPath.section : indexPath.section - allDayTasks.count
        let row = indexPath.row
        repository.updateTodoStatus(todo: tasks[section].todos[row])
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
