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
        view.textColor = .textColor
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 13.5, weight: .semibold)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textColor
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
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tableBgColor
        view.layer.borderColor = UIColor.tableBgColor.cgColor
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        [dateLabel, lineView, titleLabel, fullDateLabel, separatorView].forEach { view.addSubview($0) }
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
        contentView.addSubview(backView)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalTo(separatorView.snp.top).inset(-6)
            make.width.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.leading.equalTo(dateLabel.snp.trailing).offset(4)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalTo(separatorView.snp.top).inset(-6)
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
            make.bottom.equalTo(separatorView.snp.top).inset(-6)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
