//
//  MonthlyTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import UIKit

class MonthlyTableViewCell: BaseTableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: MonthlyCollectionViewLayout())
        view.backgroundColor = .clear
        view.isPagingEnabled = false
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
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
        collectionView.register(MonthlyCollectionViewCell.self, forCellWithReuseIdentifier: MonthlyCollectionViewCell.reuseIdentifier)
        contentView.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
    static func MonthlyCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        let itemWidth: CGFloat = deviceWidth - 44
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        layout.itemSize = CGSize(width: itemWidth, height: 50)
        return layout
    }
}

class TableViewAddEventCell: BaseTableViewCell {
    var vc: MonthlyViewController?
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    lazy var addNewEventBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("새로운 일정 추가", for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .bgColor // TODO: 버튼 색 바꾸기
        btn.addTarget(self, action: #selector(addNewEventBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    @objc func addNewEventBtnClicked() {
        vc?.present(WriteViewController(), animated: true)
    }
    
    /* // TODO: 템플릿 기능 추가해주기 - iOS 14+ pop-up btn or https://github.com/AssistoLab/DropDown
    let templateBtn: UIButton = {
        let btn = UIButton()
        let buttonMenu = UIMenu(title: "템플릿", children: [])
        if #available(iOS 14.0, *) {
            btn.menu = buttonMenu
        } else {
            // Fallback on earlier versions
        }
        return btn
    }()
    */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        contentView.addSubview(addNewEventBtn)
    }
    
    override func setConstraints() {
        addNewEventBtn.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
