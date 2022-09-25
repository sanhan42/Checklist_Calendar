//
//  CkeckListHeaderView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/22.
//

import UIKit

class CheckListHeaderView: BaseView {
    let lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 13, weight: .semibold)
        return view
    }()
    
    let fullDateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .placeholderText
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = false
        view.font = .systemFont(ofSize: 9)
        view.numberOfLines = 1
        return view
    }()
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.square.fill"), for: .normal)
        btn.tintColor = .textColor.withAlphaComponent(0.8)
        return btn
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        [lineView, titleLabel, fullDateLabel, addButton].forEach { view.addSubview($0) }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = .clear // TODO: 실질적인 셀 아이템 배경색
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
        self.backgroundColor = .clear // 컬렉션뷰 배경색
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.leading.equalToSuperview().offset(4)
            make.top.equalToSuperview().inset(2.2)
            make.bottom.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(12)
            make.trailing.equalTo(addButton.snp.leading)
            make.top.equalToSuperview().inset(2)
        }
        
        fullDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(2)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(28)
        }
    }
}
