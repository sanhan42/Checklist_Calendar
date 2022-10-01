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
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.register(CheckListTableCell.self, forCellReuseIdentifier: CheckListTableCell.reuseIdentifier)
        view.sectionHeaderHeight = 38
        view.addSubview(emptyView)
        return view
    }()
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.label.text = isHiding ? "등록된 이후 일정이 없네요.\n\n먼저 이벤트를 등록해주세요 :)" : "등록된 이벤트들의 체크리스트를\n한 눈에 볼 수 있는 페이지입니다.\n\n먼저 이벤트를 등록해주세요 :)"
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
        navigationController?.presentationController?.delegate = self
        addView()
        setNavigationLeftItems()
        setNavigationRightItems()
    }
    
    func addView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        emptyView.isHidden = !allDayTasks.isEmpty || !notAllDayTasks.isEmpty
    }
    
    func setNavigationLeftItems() {
        let titleBtn: UIView = {
            let bgView = UIView()
            let btn = UIButton()
            btn.setTitle(selectedDate.toString(format: selectedDate.toString(format: "MM월 dd일 EEEE")), for: .normal)
            btn.tintColor = .textColor.withAlphaComponent(0.9)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(.textColor, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            btn.contentHorizontalAlignment = .center
            btn.addTarget(self, action: #selector(calendarBtnClicked), for: .touchUpInside)
            bgView.addSubview(btn)
            bgView.snp.makeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(28)
            }
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return bgView
        }()
        
        let cancelBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "xmark"), for: .normal)
            btn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
            btn.tintColor = .textColor.withAlphaComponent(0.8)
            btn.snp.makeConstraints { make in
                make.width.height.equalTo(21.5)
            }
            return btn
        }()
        
        navigationController?.navigationBar.topItem?.leftBarButtonItems = [UIBarButtonItem(customView: cancelBtn), UIBarButtonItem(customView: titleBtn)]
    }
    
    func setNavigationRightItems() {
       
        let todayBtn: UIView = {
            let bgView = UIView()
            let btn = UIButton()
            btn.setTitle("오늘 ", for: .normal)
            btn.setImage(UIImage(named: "cherry"), for: .normal)
            btn.setTitleColor(.textColor.withAlphaComponent(0.65), for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.font = .systemFont(ofSize: 11.6, weight: .bold)
            btn.contentHorizontalAlignment = .center
            btn.semanticContentAttribute = .forceRightToLeft
            btn.imageEdgeInsets = .init(top: 2.2, left: 15.5, bottom: 2.6, right: 15)
            btn.addTarget(self, action: #selector(moveToToday), for: .touchUpInside)
            bgView.layer.borderColor = UIColor.textColor.withAlphaComponent(0.5).cgColor
            bgView.layer.borderWidth = 1.8
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
            btn.setTitleColor(UIColor.textColor.withAlphaComponent(0.65), for: .normal)
            btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.5).cgColor
            btn.layer.borderWidth = 1.8
            btn.layer.cornerRadius = 12
            btn.addTarget(self, action: #selector(hideBtnClicked), for: .touchUpInside)
            btn.snp.makeConstraints { make in
                make.width.equalTo(96)
            }
            let title = isHiding ? "모든 일정 보기" : "지난 일정 숨기기"
            btn.setTitle(title, for: .normal)
            return btn
        }()
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(customView: hideBtn), UIBarButtonItem(customView: todayBtn)]
    }
}

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = 0..<allDayTasks.count ~= indexPath.section ? indexPath.section : indexPath.section - allDayTasks.count
        let tasks: Results<Event> = 0..<allDayTasks.count ~= indexPath.section ? allDayTasks : notAllDayTasks
        return tasks[section].todos[indexPath.row].title.heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 13)) + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CheckListHeaderView()
        let tasks: Results<Event> = allDayTasks.isEmpty || section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let index = allDayTasks.isEmpty || section < allDayTasks.count ? section : section - allDayTasks.count
        header.lineView.backgroundColor = UIColor(hexAlpha: tasks[index].color)
        header.titleLabel.text = tasks[index].title
        header.fullDateLabel.text = tasks[index].startTime.getDateStr(day: selectedDate, needOneLine: true) + " → " + tasks[index].endTime.getDateStr(day: selectedDate, needOneLine: true)
        header.addButton.tag = section
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
        cell.textView.attributedText = tasks[section].todos[indexPath.row].isDone ? tasks[section].todos[indexPath.row].title.strikeThrough() : tasks[section].todos[indexPath.row].title.regular()
        cell.textView.tag = tagNum
        cell.textView.delegate = self
        let img = tasks[section].todos[indexPath.row].isDone ? UIImage(systemName: "checkmark.square")?.imageWithColor(color: .textColor.withAlphaComponent(0.5)) : UIImage(systemName: "square")?.imageWithColor(color: .textColor)
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
    @objc func cancelBtnClicked() {
        afterDissmiss?()
        dismiss(animated: true)
    }
    
    @objc func hideBtnClicked() {
        isHiding.toggle()
        fetchRealm(isHiding: isHiding)
        setNavigationRightItems()
        emptyView.isHidden = !allDayTasks.isEmpty || !notAllDayTasks.isEmpty
        emptyView.label.text = isHiding ? "등록된 이후 일정이 없네요.\n\n먼저 이벤트를 등록해주세요 :)" : "등록된 이벤트들의 체크리스트를\n한 눈에 볼 수 있는 페이지입니다.\n\n먼저 이벤트를 등록해주세요 :)"
        tableView.reloadData()
    }

    @objc func calendarBtnClicked() {
        showDatePickerPopup(mode: .date) { [self] _ in
            selectedDate = datePicker.date
            setNavigationLeftItems()
            fetchRealm(isHiding: isHiding)
            emptyView.isHidden = !allDayTasks.isEmpty || !notAllDayTasks.isEmpty
            tableView.reloadData()
        }
    }
    
    @objc func moveToToday() {
        selectedDate = Date()
        datePicker.date = selectedDate
        setNavigationLeftItems()
        fetchRealm(isHiding: isHiding)
        emptyView.isHidden = !allDayTasks.isEmpty || !notAllDayTasks.isEmpty
        tableView.reloadData()
    }
    
    @objc func addBtnClicked(_ sender: UIButton) {
        let section = sender.tag
        let tasks: Results<Event> = allDayTasks.isEmpty || section >= allDayTasks.count  ? notAllDayTasks : allDayTasks
        let index = allDayTasks.isEmpty || section < allDayTasks.count ? section : section - allDayTasks.count
        repository.addTodoInEvent(event: tasks[index])
        fetchRealm()
        tableView.reloadSections([section], with: .fade)
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
