//
//  TodoTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class TodoTableViewCell: BaseTableViewCell {
    let checkListTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .bgColor
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
    }
    
    override func setConstraints() {
        checkListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
