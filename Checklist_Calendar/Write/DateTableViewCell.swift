//
//  DateTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class DateTableViewCell: BaseTableViewCell {
    let clockImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "calendar.badge.clock"))
        view.tintColor = .textColor
        return view
    }()
    
    let allDayLabel: UILabel = {
        let label = UILabel()
        label.text = "하루 종일"
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    let allDaySwitch: UISwitch = {
        let btn = UISwitch(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        btn.onTintColor = UIColor(named: "PinkColor")
        return btn
    }()
    
    lazy var titleView: UIView = {
        let view = UIView()
        [clockImageView, allDayLabel, allDaySwitch].forEach{ view.addSubview($0) }
        return view
    }()
    
    let startDateBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("22/09/17(토)", for: .normal) // TODO: 임시값
        btn.setTitleColor(UIColor.textColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    let endDateBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("22/09/17(토)", for: .normal) // TODO: 임시값
        btn.setTitleColor(UIColor.textColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    let startTimeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("오전 09:00", for: .normal) // TODO: 임시값
        btn.setTitleColor(UIColor.textColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    let endTimeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("오전 10:00", for: .normal) // TODO: 임시값
        btn.setTitleColor(UIColor.textColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    let arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "arrow.right"))
        view.tintColor = .textColor
        return view
    }()
    
    lazy var dateView: UIView = {
        let view = UIView()
        [startDateBtn, arrowImageView, endDateBtn].forEach{ view.addSubview($0) }
        return view
    }()
    
    lazy var timeView: UIView = {
        let view = UIView()
        [startTimeBtn, endTimeBtn].forEach{ view.addSubview($0) }
        return view
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
        [titleView, dateView, timeView].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        let height = 36
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(height)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        allDayLabel.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(100)
            make.top.equalToSuperview()
            make.leading.equalTo(clockImageView.snp.trailing).offset(20)
        }
        
        allDaySwitch.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        dateView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.top.equalTo(titleView.snp.bottom)
            make.height.equalTo(height)
//            make.width.equalToSuperview().inset(40)
        }
        
        timeView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.top.equalTo(dateView.snp.bottom)
            make.height.equalTo(28)
//            make.width.equalToSuperview().inset(40)
        }
        
        [startDateBtn, endDateBtn].forEach({ item in
            item.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(height)
            }
        })
        
        [startTimeBtn, endTimeBtn].forEach({ item in
            item.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(28)
            }
        })
        
        [startDateBtn, startTimeBtn].forEach({ item in
            item.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(20)
            }
        })
        
        [endDateBtn, endTimeBtn].forEach({ item in
            item.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(20)
            }
        })
        
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
