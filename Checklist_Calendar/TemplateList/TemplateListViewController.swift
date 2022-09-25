//
//  TemplateListViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/24.
//

import UIKit
import RealmSwift
import SwiftUI

class TemplateListViewController: BaseViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .tableBgColor
        view.separatorStyle = .none
        view.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        view.register(TemplateListTableCell.self, forCellReuseIdentifier: TemplateListTableCell.reuseIdentifier)
        view.rowHeight = 48
        view.tableHeaderView = nil
        view.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        return view
    }()
    
    let repository = EventRepository()
    
    var templateTasks: Results<Template>!
    
    var afterDissmiss: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar() 
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
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        title = "템플릿"
        let cancleItem = UIBarButtonItem(image: UIImage(systemName: "xmark.square"), style: .plain, target: self, action: #selector(cancleBtnClicked))
        cancleItem.tintColor = .textColor
        let saveItem = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: self, action: #selector(addBtnClicked))
        saveItem.tintColor = .textColor
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveItem
    }
    
    @objc private func cancleBtnClicked() {
        afterDissmiss?()
        dismiss(animated: true)
    }
    
    @objc private func addBtnClicked() {
        let vc = WriteViewController()
        vc.isTemplatePage = true
        vc.afterDissmiss = {
            self.tableView.reloadData()
        }
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }
}

extension TemplateListViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateTasks.isEmpty ? 1 : templateTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if templateTasks.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.label.text = "등록된 템플릿이 없습니다."
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateListTableCell.reuseIdentifier, for: indexPath) as? TemplateListTableCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.dateLabel.text = templateTasks[indexPath.row].startTime.toString(format: SHDate.time.str())
        cell.lineView.backgroundColor = UIColor(hexAlpha: templateTasks[indexPath.row].color)
        cell.titleLabel.text = templateTasks[indexPath.row].title
        cell.fullDateLabel.text = templateTasks[indexPath.row].startTime.toString(format: SHDate.time.str()) + "->" + templateTasks[indexPath.row].endTime.toString(format: SHDate.time.str())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        vc.realmTemplate = templateTasks[indexPath.row]
        vc.isTemplatePage = true
        vc.afterDissmiss = {
            self.tableView.reloadRows(at: [[0, indexPath.row]], with: .automatic)
        }
        let navi = UINavigationController(rootViewController: vc)
        self.present(navi, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: nil, message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                
                self.repository.deleteTemplate(template: self.templateTasks[indexPath.row])
                self.tableView.reloadData()
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

extension TemplateListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        afterDissmiss?()
    }
}

