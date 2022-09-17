//
//  TitleTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class TitleTableViewCell: BaseTableViewCell {
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .textColor
        tf.textAlignment = .left
        return tf
    }()
    
    let colorButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemPink // TODO: 임시로 색을 넣어둠
        return btn
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
        [titleTextField, colorButton].forEach { v in
            contentView.addSubview(v)
        }
    }
    
    override func setConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(50)
            make.leading.verticalEdges.equalToSuperview()
        }
        
        colorButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        colorButton.layer.cornerRadius = 8
    }
}
