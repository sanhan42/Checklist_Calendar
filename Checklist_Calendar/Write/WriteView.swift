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
        view.backgroundColor = .tableBgColor //.bgColor // TODO: 임시 색상 => 수정 필요
        view.separatorStyle = .none
        view.tag = 0
        return view
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.9).cgColor
        btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        return btn
    }()
    
    let okBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("확인", for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.9).cgColor
        btn.backgroundColor = .bgColor
        return btn
    }()
    
    lazy var btnStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancelBtn, okBtn])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
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
        addSubview(btnStackView)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.reuseIdentifier)
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier:TodoTableViewCell.reuseIdentifier)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(btnStackView.snp.top)
        }
        
        btnStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
