//
//  EmptyCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/24.
//

import UIKit

class EmptyCell: BaseTableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .textColor.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
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
        contentView.addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
    }
}
