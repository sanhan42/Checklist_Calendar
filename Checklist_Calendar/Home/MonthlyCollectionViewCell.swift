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
        view.adjustsFontSizeToFitWidth = true
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        self.backgroundColor = .bgColor // TODO: 컬렉션뷰 배경색 수정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [dateLabel, lineView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(4)
            make.width.equalTo(60)
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
