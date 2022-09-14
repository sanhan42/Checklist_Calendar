//
//  BaseView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {}
}
