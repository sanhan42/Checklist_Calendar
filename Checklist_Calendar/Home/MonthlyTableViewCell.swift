//
//  MonthlyTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import UIKit

class MonthlyTableViewCell: BaseTableViewCell {
    
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
