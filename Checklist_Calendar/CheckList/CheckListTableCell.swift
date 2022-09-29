//
//  CheckListTableCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/25.
//

import UIKit

class CheckListTableCell: BaseTableViewCell {
   
    let checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.dashed"), for: .normal)
        btn.tintColor = .textColor
        return btn
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textAlignment = .left
        view.isEditable = true
        view.textColor = .textColor.withAlphaComponent(0.9)
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.grayColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.8
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy private var btnBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.grayColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.8
        view.layer.cornerRadius = 3
        view.addSubview(checkButton)
        return view
    }()
    
    lazy private var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.grayColor.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        [btnBgView, textView].forEach{ view.addSubview($0) }
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
        contentView.addSubview(bgView)
    }
    
    override func setConstraints() {
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview()
        }
        
        btnBgView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(1)
            make.width.equalTo(32)
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview()
            make.topMargin.equalToSuperview().inset(4)
        }
        
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(1)
            make.leading.equalTo(btnBgView.snp.trailing)
            make.trailing.equalToSuperview().inset(1.2)
        }
    }
}
