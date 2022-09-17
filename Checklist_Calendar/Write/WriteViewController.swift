//
//  WriteViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/16.
//

import UIKit

class WriteViewController: BaseViewController {
    let mainView = WriteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        super.configure()
        view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell()}
        return cell
    }
    
    
}
