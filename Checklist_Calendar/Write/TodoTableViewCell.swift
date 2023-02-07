//
//  TodoTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class TodoTableViewCell: BaseTableViewCell {
    let checkListTableView: UITableView = {
        let view = UITableView(frame: .null, style: .grouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.tag = 1
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        contentView.addSubview(checkListTableView)
        checkListTableView.register(CheckListTableViewCell.self, forCellReuseIdentifier: CheckListTableViewCell.reuseIdentifier)
    }
    
    override func setConstraints() {
        checkListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
