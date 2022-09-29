//
//  NotiTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/28.
//

import UIKit

class NotiTableViewCell: BaseTableViewCell {

    let bellImgView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "bell"))
        view.tintColor = .textColor
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 17.6, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 17.8, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    let chevronImgView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.tintColor = .placeholderText
        return view
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
        [bellImgView, label, valueLabel, chevronImgView, separatorView].forEach { v in
            contentView.addSubview(v)
        }
        contentView.backgroundColor = .bgColor
    }
    
    override func setConstraints() {
        bellImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(bellImgView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(24)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImgView.snp.leading).inset(-12)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
}
