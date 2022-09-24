//
//  TemplateListTableCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/24.
//

import UIKit

class TemplateListTableCell: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "하루 종일"
        view.textColor = .textColor
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 3
        view.font = .systemFont(ofSize: 13.5, weight: .semibold)
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
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let fullDateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .placeholderText
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = false
        view.font = .systemFont(ofSize: 10)
        view.numberOfLines = 1
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        [dateLabel, lineView, titleLabel, fullDateLabel].forEach { view.addSubview($0) }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = .bgColor // TODO: 실질적인 셀 배경색
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        contentView.addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.verticalEdges.equalToSuperview().inset(4)
            make.width.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.leading.equalTo(dateLabel.snp.trailing).offset(4)
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
