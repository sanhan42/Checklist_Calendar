//
//  EmptyView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/30.
//

import UIKit

class EmptyView: BaseView {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .textColor.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureUI() {
        addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
