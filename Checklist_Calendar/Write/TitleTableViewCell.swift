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
        tf.placeholder = "제목"
        tf.font = .systemFont(ofSize: 20, weight: .black)
        tf.textAlignment = .left
        return tf
    }()
    
    lazy var textNumLabel: UILabel = {
        let label = UILabel()
        label.text = "\(titleTextField.text?.count ?? 0)/25"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .placeholderText
        label.textAlignment = .left
        return label
    }()
    
    let colorButton: UIColorWell = {
        let btn = UIColorWell(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.selectedColor = .systemPink // TODO: 기본색 설정 때 수정 필요
        return btn
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .GrayColor.withAlphaComponent(0.8)
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
        [titleTextField, textNumLabel, colorButton, separatorView].forEach { v in
            contentView.addSubview(v)
        }
        contentView.backgroundColor = .bgColor
    }
    
    override func setConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(65)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        textNumLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.leading.equalTo(titleTextField.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
        }
        
        colorButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
