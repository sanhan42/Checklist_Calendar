//
//  NotificationViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/28.
//

import UIKit
import SwiftUI

class NotificationViewController: BaseViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.register(CheckListTableCell.self, forCellReuseIdentifier: CheckListTableCell.reuseIdentifier)
        view.sectionHeaderHeight = 38
        return view
    }()
  
    var afterDissmiss: (() -> ())?
   
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
        self.navigationController?.isModalInPresentation = true
        title = "알림"
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return 1
        case 1 : return 10
        default : return 0
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
        
        return cell
    }
    
}

extension NotificationViewController {
    
}
