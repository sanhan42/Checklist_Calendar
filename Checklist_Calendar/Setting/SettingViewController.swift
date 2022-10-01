//
//  SettingViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/29.
//

import UIKit
import SwiftUI
import Zip
import MessageUI
import AcknowList
import MobileCoreServices
import UniformTypeIdentifiers

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "데이터"
        case 1 : return "기타"
        default : return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.tintColor = .textColor
        cell.selectionStyle = .none
        var text: String
        
        if indexPath.section == 0 {
            cell.imageView?.image = indexPath.row == 0 ? UIImage(systemName: "externaldrive.badge.plus") : UIImage(systemName: "externaldrive.badge.timemachine")
            text = indexPath.row == 0 ? "백업 파일 생성" : "복구 하기"
        } else {
            cell.imageView?.image = indexPath.row == 0 ? UIImage(systemName: "ellipses.bubble") : UIImage(systemName: "list.bullet.rectangle")
            text = indexPath.row == 0 ? "문의 남기기" : "오픈 소스"
        }
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 : backupBtnClicked()
            case 1 : restoreBtnClicked()
            default : return
            }
        } else {
            switch indexPath.row {
            case 0 : feedbackBtnClicked()
            case 1 : showOpenSourceList()
            default : return
            }
        }
    }
}

extension SettingViewController {
    private func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let directoryPath = path.first {
            return directoryPath
        } else {
            return nil
        }
    }
    
    private func presentActivityViewController() {
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("CherryCal_archive.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func backupBtnClicked() {
            var urlPaths = [URL]()
            if let path = documentDirectoryPath() {
                let realm = (path as NSString).appendingPathComponent("default.realm")
                if FileManager.default.fileExists(atPath: realm) {
                    urlPaths.append(URL(string: realm)!)
                } else {
                    showAlertMessage(title: "백업할 파일이 없습니다.")
                    return
                }
            }
            
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "CherryCal_archive")
            print("압축 경로: \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
            showAlertMessage(title: "압축에 실패하였습니다.")
        }
    }
    
    private func restoreBtnClicked() {
        let alert = UIAlertController(title: "주의!", message: "복구를 진행 시, 선택한 백업 파일 상태로 돌아가게 됩니다. 복구를 계속 진행하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            var vc: UIDocumentPickerViewController!
            if #available(iOS 14, *) {
                // iOS 14 & later
                let supportedTypes: [UTType] = [UTType.archive]
                vc = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
            } else {
                // iOS 13 or older code
                vc = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
            }
            vc.delegate = self
            vc.allowsMultipleSelection = false //여러가지 선택지
            self.present(vc, animated: true, completion: nil)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
    
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
                UIPasteboard.general.string = "42.sanhan@gmail.com"
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

extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일에 오류가 있습니다.")
            return
        }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            //기존에 복구하고자 하는 zip파일을 로컬에 도큐먼트에 가지고 있을 경우, 도큐먼트에 위치한 zip을 압축 해제 하면 됨!
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("CherryCal_archive.zip")
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    let alert = UIAlertController(title: "복구가 완료되었습니다.", message: "앱을 다시 실행해주세요:)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) {_ in
                        print("OK")
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("CherryCal_archive.zip")
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    let alert = UIAlertController(title: "복구가 완료되었습니다.", message: "앱을 다시 실행해주세요:)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) {_ in
                        print("OK")
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
