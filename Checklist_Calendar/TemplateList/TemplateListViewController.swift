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
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        view.register(TemplateListTableCell.self, forCellReuseIdentifier: TemplateListTableCell.reuseIdentifier)
        view.rowHeight = 38
        view.sectionHeaderHeight = 38
        return view
    }()
    
    let repository = EventRepository()
    
    var templateTasks: Results<Template>!
    
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
        
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        title = "템플릿"
        let cancleItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app"), style: .plain, target: self, action: #selector(cancleBtnClicked))
        cancleItem.tintColor = .textColor
        let saveItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addBtnClicked))
        saveItem.tintColor = .textColor
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveItem
    }
    
    @objc private func cancleBtnClicked() {
        dismiss(animated: true)
    }
    
    @objc private func addBtnClicked() {
        let vc = WriteViewController()
        vc.isTemplatePage = true
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
            cell.label.text = "등록된 템플릿이 없습니다."
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateListTableCell.reuseIdentifier, for: indexPath) as? TemplateListTableCell else { return UITableViewCell() }
        cell.dateLabel.text = templateTasks[indexPath.row].startTime.toString(format: SHDate.time.str())
        cell.lineView.backgroundColor = UIColor(hexAlpha: templateTasks[indexPath.row].color)
        cell.titleLabel.text = templateTasks[indexPath.row].title
        cell.fullDateLabel.text = templateTasks[indexPath.row].startTime.toString(format: SHDate.time.str()) + "->" + templateTasks[indexPath.row].endTime.toString(format: SHDate.time.str())
        return cell
    }
}
