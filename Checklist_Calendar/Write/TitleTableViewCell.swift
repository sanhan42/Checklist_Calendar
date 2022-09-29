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
        tf.adjustsFontSizeToFitWidth = true
        tf.font = .systemFont(ofSize: 18, weight: .black)
        tf.textAlignment = .left
        return tf
    }()
    
    lazy var textNumLabel: UILabel = {
        let label = UILabel()
        label.text = "\(titleTextField.text?.count ?? 0)/20"
        label.font = .systemFont(ofSize: 7.5)
        label.textColor = .placeholderText
        label.textAlignment = .left
        return label
    }()
    
    let colorButton: UIColorWell = {
        let btn = UIColorWell(frame: CGRect(x: 100, y: 100, width: 85, height: 85))
        btn.selectedColor = .redColor
        return btn
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayColor.withAlphaComponent(0.8)
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
            make.width.equalToSuperview().inset(48)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        textNumLabel.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.leading.equalTo(titleTextField.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
        
        colorButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
}
