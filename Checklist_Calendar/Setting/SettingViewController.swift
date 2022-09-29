//
//  SettingViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/29.
//

import UIKit
import SwiftUI
import MessageUI
import AcknowList

class SettingViewController: BaseViewController {
    var selectedRow = 0
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .insetGrouped)
        view.backgroundColor = .bgColor
        view.separatorStyle = .none
        view.backgroundColor = .tableBgColor
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavi()
    }
    
    override func configure() {
        super.configure()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setNavi() {
        title = "설정"
        let cancelBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "xmark"), for: .normal)
            btn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
            btn.tintColor = .textColor.withAlphaComponent(0.8)
            btn.snp.makeConstraints { make in
                make.width.height.equalTo(21.5)
            }
            return btn
        }()
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.image = indexPath.row == 0 ? UIImage(systemName: "ellipses.bubble") : UIImage(systemName: "list.bullet.rectangle")
        cell.imageView?.tintColor = .textColor
        var text: String
        switch indexPath.row {
        case 0 : text = "문의 남기기"
        case 1 : text = "오픈 소스"
        default : text = ""
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 : feedbackBtnClicked()
        case 1 : showOpenSourceList()
        default : return
        }
    }
}

extension SettingViewController {
    @objc private func cancelBtnClicked() {
        dismiss(animated: true)
    }
    
    // Device Identifier 찾기
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    private func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    private func feedbackBtnClicked() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                                     이곳에 내용을 작성해주세요.
                                     
                                     -------------------------------------------
                                     
                                     Device Model : \(self.getDeviceIdentifier())
                                     Device OS : \(UIDevice.current.systemVersion)
                                     App Version : \(self.getCurrentVersion())
                                     
                                     -------------------------------------------
                                     """
            composeViewController.setToRecipients(["42.sanhan@gmail.com"])
            composeViewController.setSubject("[체리캘린더] 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            self.present(composeViewController, animated: true, completion:  nil)
        } else {
            let sendMailErrorAlert = UIAlertController(title: "메일 주소 복사", message: "클립보드에 복사된 메일 주소(42.sanhan@gmail.com)로 소중한 의견을 남겨주시면 감사하겠습니다 :D", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                UIPasteboard.general.string = "42.sanhan@gmail.com"
            }
            sendMailErrorAlert.addAction(ok)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    private func showOpenSourceList() {
        let viewController = AcknowListViewController()
        viewController.headerText = "사용한 오픈소스 라이브러리 목록"
        viewController.tableView.backgroundColor = .tableBgColor
        navigationController?.navigationBar.tintColor = .textColor
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = .textColor
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.dismiss(animated: true, completion: nil)
    }
}
