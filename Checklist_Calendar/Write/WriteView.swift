//
//  WriteView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class WriteView: BaseView {
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .tableBgColor
        view.separatorStyle = .none
        view.tag = 0
        view.isScrollEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureUI() {
        backgroundColor = .tableBgColor
        addSubview(tableView)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.reuseIdentifier)
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier:TodoTableViewCell.reuseIdentifier)
        tableView.register(NotiTableViewCell.self, forCellReuseIdentifier: NotiTableViewCell.reuseIdentifier)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
       
    }
}
