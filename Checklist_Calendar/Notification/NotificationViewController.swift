//
//  NotificationViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/28.
//

import UIKit
import SwiftUI

class NotificationViewController: BaseViewController {
    var selectedRow = 0
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.backgroundColor = .tableBgColor
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        title = "알림"
        navigationController?.navigationBar.tintColor = .textColor
        let vc = navigationController?.viewControllers[0] as! WriteViewController
        vc.notificationCenter.getNotificationSettings { setting in
            if setting.authorizationStatus != .authorized {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNonzeroMagnitude : 10
    }
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .bgColor
        cell.imageView?.image = (indexPath.section + indexPath.row) != selectedRow ? UIImage(systemName: "square") : UIImage(systemName: "checkmark.square")
        cell.imageView?.tintColor = .textColor
        cell.selectionStyle = .none
        var text: String
        if indexPath.section == 0 {
            text = "없음"
        } else {
            switch indexPath.row {
            case 0 : text = "이벤트 당시"
            case 1 : text = "5분 전"
            case 2 : text = "10분 전"
            case 3 : text = "15분 전"
            case 4 : text = "30분 전"
            case 5 : text = "1시간 전"
            case 6 : text = "2시간 전"
            case 7 : text = "1일 전"
            case 8 : text = "2일 전"
            case 9 : text = "1주 전"
            default : text = ""
            }
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.section + indexPath.row
        guard let vc = self.navigationController?.viewControllers[0] as? WriteViewController else {
            tableView.reloadData()
            return
        }
        vc.event.notiOption = selectedRow
        self.navigationController?.popViewController(animated: true)
        vc.mainView.tableView.reloadRows(at: [[0, 2]], with: .none)
    }
}
