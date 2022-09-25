//
//  MonthlyTableViewHeaderView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/18.
//

import UIKit

class MonthlyTableViewHeaderView: BaseView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .textColor.withAlphaComponent(0.65)
        return label
    }()
    
    let hideBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.textColor.withAlphaComponent(0.8), for: .normal)
        btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.65).cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    let checkListBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        btn.setImage(UIImage(systemName: "checklist"), for: .normal)
        btn.tintColor = UIColor.textColor.withAlphaComponent(0.65)
        btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.65).cgColor
        btn.layer.borderWidth = 1.8
        btn.layer.cornerRadius = 2
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(hideBtn)
        addSubview(checkListBtn)

    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        checkListBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.width.equalTo(28)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        hideBtn.snp.makeConstraints { make in
            make.trailing.equalTo(checkListBtn.snp.leading).inset(-12)
            make.width.equalTo(100)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    
}
