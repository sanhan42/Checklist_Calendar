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
        tf.placeholder = "할 일을 입력해주세요"
        tf.textColor = .textColor
        return tf
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
        [checkButton, textField].forEach { v in
            contentView.addSubview(v)
        }
    }
    
    override func setConstraints() {
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
