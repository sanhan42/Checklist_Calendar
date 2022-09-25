//
//  CheckListTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/19.
//

import UIKit

class CheckListTableViewCell: BaseTableViewCell {
   
    let checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.dashed"), for: .normal)
        btn.tintColor = .textColor
        return btn
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "새로운 할 일 추가"
        tf.textColor = .textColor
        return tf
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        [checkButton, textField].forEach{ view.addSubview($0) }
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
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}
