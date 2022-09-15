//
//  MonthlyTableViewCell.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/14.
//

import UIKit

class MonthlyTableViewCell: BaseTableViewCell {
    let collectionView: UICollectionView = {
        let view = UICollectionView() 
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
