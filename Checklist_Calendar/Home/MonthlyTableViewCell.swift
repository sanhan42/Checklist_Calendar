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
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let width = window?.safeAreaLayoutGuide.layoutFrame.width ?? UIScreen.main.bounds.width
        let height = window?.safeAreaLayoutGuide.layoutFrame.height ?? UIScreen.main.bounds.height
        let itemWidth: CGFloat = width > height ? (width/2 - 26) : (width - 44) // TODO: 아이패드나 다른 기기에서 가로 모드로 테스트 해봐야함.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        layout.itemSize = CGSize(width: itemWidth, height: 46)
        return layout
    }
}
