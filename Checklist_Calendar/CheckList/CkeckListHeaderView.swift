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
        view.backgroundColor = .systemRed // TODO: 기본색 설정
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "TEST!!!!!!!!"
        view.textColor = .black
        view.font = .systemFont(ofSize: 13)
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
    
    lazy var backView: UIView = {
        let view = UIView()
        [lineView, titleLabel, fullDateLabel].forEach { view.addSubview($0) }
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
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 2
        addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.leading.equalToSuperview().offset(4)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(6)
        }
        
        fullDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(6)
        }
    }
}
