//
//  MonthlyCollectionViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/15.
//

import UIKit

class MonthlyCollectionViewCell: BaseCollectionViewCell {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "하루 종일"
        view.textColor = .black
        view.textAlignment = .center
//        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 2
        // TODO: 폰트 크기, 줄 수 => 분기 처리 해줘야 함.
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed // TODO: 기본색 설정
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "TEST!!!!!!!!"
        view.textColor = .black
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        [dateLabel, lineView, titleLabel].forEach { view.addSubview($0) }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = .bgColor // TODO: 실질적인 셀 아이템 배경색
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        self.backgroundColor = .clear // 컬렉션뷰 배경색
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
//        [dateLabel, lineView, titleLabel].forEach { contentView.addSubview($0) }
        contentView.addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.verticalEdges.equalToSuperview().inset(4)
            make.width.equalTo(80)
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.leading.equalTo(dateLabel.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(12)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
}
