//
//  MonthlyViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import FSCalendar
import RealmSwift
import SnapKit
import SwiftUI

class MonthlyViewController: BaseViewController {
    
    let mainView = MonthlyView()
    let repository = EventRepository()
    let notificationCenter = UNUserNotificationCenter.current()
    
    var allDayTasks: Results<Event>!
    var notAllDayTasks: Results<Event>!
    var templateTasks: Results<Template>!
    var notAllDayArr: [[Event]] = [] // [테이블셀 row][컬렉션뷰셀의 item]
    
    var dayEventCount: Int {
        return allDayTasks.count + notAllDayTasks.count
    }
    
    var isHiding = false
    var isFiest = true
    
    lazy var lunarDate = calLunarDate()
    lazy var selectedDate = mainView.calendar.selectedDate ?? Date()
    
    private var collectionViewLayout: UICollectionViewFlowLayout?
    
    lazy var dismissHandler = {
        self.fetchRealm(date: self.mainView.calendar.selectedDate ?? Date())
        self.mainView.calendar.reloadData()
        self.mainView.tableView.reloadData()
    }
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.mainView.calendar, action: #selector(self.mainView.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    func calLunarDate() -> String {
        let chineseCalendar = Calendar(identifier: .chinese)
        let formatter = DateFormatter()
        formatter.dateFormat = "음력 MM월 dd일"
        formatter.calendar = chineseCalendar
        let date = mainView.calendar.selectedDate ?? Date()
        return formatter.string(from: date)
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchRealm(date: mainView.calendar.selectedDate ?? Date())
        setToolbar()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        lazy var calWidth =  (window?.safeAreaLayoutGuide.layoutFrame.height ?? UIScreen.main.bounds.height)
        mainView.calendar.fs_width = calWidth
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.isNavigationBarHidden = true
        
        mainView.calendar.dataSource = self
        mainView.calendar.delegate = self
        
        mainView.titleButton.addTarget(self, action: #selector(setTitleDate), for: .touchUpInside)
        mainView.todayBtn.addTarget(self, action: #selector(moveToToday), for: .touchUpInside)
        
        mainView.addGestureRecognizer(scopeGesture)
        mainView.tableView.panGestureRecognizer.require(toFail: scopeGesture)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.tag = -1
        mainView.tableView.register(MonthlyTableViewCell.self, forCellReuseIdentifier: MonthlyTableViewCell.reuseIdentifier)
        mainView.tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResign), name: UIScene.didActivateNotification, object: nil) // UIApplication.willResignActiveNotification
    }
    
    @objc func willResign() {
        mainView.calendar.reloadData()
        mainView.tableView.reloadData()
    }
    
    func fetchRealm(date: Date) {
        allDayTasks = repository.allDayTasksFetch(date: date, isHiding:  isHiding)
        notAllDayTasks = repository.notAllDayTasksFetch(date: date, isHiding: isHiding)
        setNotAllDayArr()
        templateTasks = repository.templateTasksFetch()
    }
    
    func setNotAllDayArr() {
        var rtnArry: [[Event]] = []
        var i = 0
        while 0..<notAllDayTasks.count ~= i {
            var array: [Event] = []
            array.append(notAllDayTasks[i])
            let hour = notAllDayTasks[i].startHour
            i += 1
            while i < notAllDayTasks.count && notAllDayTasks[i].startHour == hour {
                array.append(notAllDayTasks[i])
                i += 1
            }
            rtnArry.append(array)
        }
        notAllDayArr = rtnArry
    }
    
    @objc func setTitleDate() {
        datePicker.date = mainView.calendar.selectedDate ?? Date()
        showDatePickerPopup { _ in
            self.mainView.titleButton.setTitle(self.datePicker.date.toString(format: "yyyy년 MM월"), for: .normal)
            self.mainView.calendar.select(self.datePicker.date, scrollToDate: true)
            self.calendar(self.mainView.calendar, didSelect: self.datePicker.date, at: .current)
        }
    }
    
    @objc func moveToToday() {
        mainView.calendar.select(Date())
        calendar(mainView.calendar, didSelect: Date(), at: .current)
    }
    
    
    func setToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.backgroundColor = .bgColor
        
        let btn = UIButton()
        btn.setTitle("＋ 새로운 이벤트 추가 ", for: .normal)
        btn.setTitleColor(.textColor.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.layer.borderWidth = 2
        btn.snp.makeConstraints { make in
            make.width.equalTo(self.navigationController!.toolbar.frame.width - 100)
        }
        btn.addTarget(self, action: #selector(addNewEventBtnClicked), for: .touchUpInside)
        let addNewEventBtn = UIBarButtonItem(customView: btn)
        let templateBtn = setTemplateBtn()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let settingBtn = setSettingBtn()
//        UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingBtnClicked))
        settingBtn.tintColor = .textColor.withAlphaComponent(0.8)
      
        toolbarItems = [settingBtn, space, addNewEventBtn, space, templateBtn]
    }
    
    func setSettingBtn() -> UIBarButtonItem {
        let rtn = UIButton()
        rtn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        rtn.tintColor = .textColor.withAlphaComponent(0.8)
        rtn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        rtn.addTarget(self, action: #selector(settingBtnClicked), for: .touchUpInside)
        rtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        return UIBarButtonItem(customView: rtn)
    }
    
    func setTemplateBtn() -> UIBarButtonItem {
        let rtn = UIButton()
        rtn.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            rtn.changesSelectionAsPrimaryAction = false
        }
        rtn.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
        rtn.tintColor = .textColor.withAlphaComponent(0.8)
        rtn.backgroundColor = .bgColor.withAlphaComponent(0.5)
        rtn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.65).cgColor
        rtn.layer.borderWidth = 1.8
        rtn.layer.cornerRadius = 4
        rtn.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        let edit = UIAction(title: "템플릿 편집", image: UIImage(systemName: "wrench.and.screwdriver")) { _ in
            let vc = TemplateListViewController()
            let navi = UINavigationController(rootViewController: vc)
            vc.templateTasks = self.templateTasks
            vc.afterDissmiss = self.setToolbar
            self.present(navi, animated: true)
        }
        var menuElement = [edit]
        if templateTasks != nil {
            for task in templateTasks {
                let img = UIImage(systemName: "plus.circle")
                let template = UIAction(title: task.title, image: img?.imageWithColor(color: UIColor(hexAlpha: task.color))) { _ in
                    var components = Calendar.current.dateComponents([.hour, .minute], from: task.startTime)
                    let date = self.mainView.calendar.selectedDate ?? Date()
                    guard let startTime = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date) else { return }
                    components = Calendar.current.dateComponents([.hour, .minute], from: task.endTime)
                    guard let endTime = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date) else { return }
                    let endDate = task.isAllDay ? date.calNextMidnight() : date
                    let event = Event(title: task.title, color: task.color, startDate: date, endDate: endDate, startTime: startTime, endTime: endTime, isAllDay: task.isAllDay, notiOption: task.notiOption)
                    for todo in task.todos {
                        let newTodo = Todo(title: todo.title, isDone: todo.isDone)
                        event.todos.append(newTodo)
                    }
                    
                    if event.notiOption != 0 {
                        self.notificationCenter.getNotificationSettings { settings in
                            guard settings.authorizationStatus == .authorized else {
                                DispatchQueue.main.async {
                                    self.repository.updateEventLotiOpt(event: event, option: 0)
                                    let alert = UIAlertController(title: "알림 권한 없음", message: "알림 등록에 실패하였습니다.", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "확인", style: .destructive)
                                    alert.addAction(ok)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                return
                            }
                            DispatchQueue.main.async {
                                let content = UNMutableNotificationContent()
                                content.title = event.title
                                content.subtitle = event.notiOption == 1 ? "이벤트 시작 시간입니다!" : "이벤트 시작 " + event.getOptionName() + " 입니다."
                                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.getNotiDate())
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                let request = UNNotificationRequest(identifier: "\(event.id)", content: content, trigger: trigger)
                                self.notificationCenter.add(request)
                            }
                        }
                    }
                    
                    self.repository.addEvent(event: event)
                    self.fetchRealm(date: date)
                    self.mainView.calendar.reloadData()
                    self.mainView.tableView.reloadData()
                }
                menuElement.append(template)
            }
        }
        let buttonMenu = UIMenu(children: menuElement)
        rtn.menu = buttonMenu
        return UIBarButtonItem(customView: rtn)
    }
    
    @objc func settingBtnClicked() {
       let vc = SettingViewController()
        let navi = UINavigationController(rootViewController: vc)
        self.present(navi, animated: true)
    }
    
    @objc func addNewEventBtnClicked() {
        let vc = WriteViewController()
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        guard let date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: selectedDate) else { return }
        vc.writeDate = date
        let navi = UINavigationController(rootViewController: vc)
        vc.afterDissmiss = dismissHandler
        self.present(navi, animated: true)
    }
    
    @objc func hideBtnClicked(_ sender: UIButton) {
        isHiding.toggle()
        fetchRealm(date: mainView.calendar.selectedDate ?? Date())
        mainView.tableView.reloadData()
    }
    
    @objc func checkListBtnClicked() {
        let vc = CheckListViewController()
        let date = mainView.calendar.selectedDate ?? Date()
        vc.allDayTasks = allDayTasks
        vc.notAllDayTasks = notAllDayTasks
        vc.selectedDate = date
        vc.isHiding = isHiding
        vc.afterDissmiss = { [self] in
            mainView.calendar.select(vc.selectedDate)
            isHiding = vc.isHiding
            dismissHandler()
        }
        let navigationVC = UINavigationController(rootViewController: vc)
        self.present(navigationVC, animated: true)
    }
}

extension MonthlyViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.mainView.tableView.contentOffset.y <= -self.mainView.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.mainView.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }
}

extension MonthlyViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        mainView.titleButton.setTitle(mainView.calendar.currentPage.toString(format: "yyyy년 MM월"), for: .normal)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendar.snp.remakeConstraints { make in
            make.top.equalTo(mainView.calHeaderView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(bounds.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            // TODO: layoutIfNeeded 메서드 검색
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        lunarDate = calLunarDate()
        selectedDate = date
        fetchRealm(date: date)
        mainView.tableView.reloadData()
    }
   
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.dayTasksFetch(date: date).isEmpty ? 0 : 1
    }
}

extension MonthlyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MonthlyTableViewHeaderView()
        header.titleLabel.text = lunarDate
        header.subtitleLabel.text = "(총 이벤트 수 : \(repository.dayTasksFetch(date: selectedDate).count))"
        header.hideBtn.addTarget(self, action: #selector(hideBtnClicked(_:)), for: .touchUpInside)
        let title = isHiding ? "모든 일정 보기" : "지난 일정 숨기기"
        header.hideBtn.setTitle(title, for: .normal)
        header.checkListBtn.addTarget(self, action: #selector(checkListBtnClicked), for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dayEventCount == 0 { return 1 }
        return allDayTasks.isEmpty ? notAllDayArr.count : notAllDayArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dayEventCount == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.label.text = "이벤트를 추가해보세요 :)"
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyTableViewCell.reuseIdentifier, for: indexPath) as? MonthlyTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.row
        cell.collectionView.collectionViewLayout = MonthlyTableViewCell.MonthlyCollectionViewLayout()
        collectionViewLayout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        cell.collectionView.reloadData()
        cell.collectionView.scrollToItem(at: [0, 0], at: .left, animated: false)
        return cell
    }
}

extension MonthlyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allDayRowNum = allDayTasks.isEmpty ? 0 : 1
        switch collectionView.tag {
        case 0:
            return allDayTasks.isEmpty ? notAllDayArr[0].count : allDayTasks.count
        case 1...(notAllDayArr.count - 1 + allDayRowNum):
            return notAllDayArr[collectionView.tag - allDayRowNum].count
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCollectionViewCell.reuseIdentifier, for: indexPath) as? MonthlyCollectionViewCell else { return UICollectionViewCell() }
        if cell.cellWidth > self.view.bounds.width { cell.cellWidth = self.view.bounds.width}
        let allDayRowNum = allDayTasks.isEmpty ? 0 : 1
        switch collectionView.tag {
        case 0:
            if !allDayTasks.isEmpty {
                cell.titleLabel.text = allDayTasks[indexPath.row].title
                cell.dateLabel.text = "하루 종일"
                cell.fullDateLabel.text = "하루 종일"
                cell.lineView.backgroundColor = UIColor(hexAlpha: allDayTasks[indexPath.row].color)
            } else {
                let event = notAllDayArr[collectionView.tag][indexPath.row]
                cell.titleLabel.text = event.title
                cell.dateLabel.text = event.startTime.getDateStr(day: selectedDate)
                cell.fullDateLabel.text = event.startTime.getDateStr(day: selectedDate, needOneLine: true) + " -> " + event.endTime.getDateStr(day: selectedDate, needOneLine: true)
                cell.lineView.backgroundColor = UIColor(hexAlpha: event.color)
            }
        case 1...(notAllDayArr.count - 1 + allDayRowNum):
            let event = notAllDayArr[collectionView.tag - allDayRowNum][indexPath.row]
            cell.titleLabel.text = event.title
            cell.dateLabel.text = event.startTime.getDateStr(day: selectedDate)
            cell.fullDateLabel.text = event.startTime.getDateStr(day: selectedDate, needOneLine: true) + " -> " + event.endTime.getDateStr(day: selectedDate, needOneLine: true)
            cell.lineView.backgroundColor = UIColor(hexAlpha: event.color)
        default : return MonthlyCollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var event: Event!
        let allDayRowNum = allDayTasks.isEmpty ? 0 : 1
        switch collectionView.tag {
        case 0:
            if !allDayTasks.isEmpty {
                event = allDayTasks[indexPath.row]
            } else {
                event = notAllDayArr[collectionView.tag][indexPath.row]
            }
        case 1...(notAllDayArr.count - 1 + allDayRowNum):
            event = notAllDayArr[collectionView.tag - allDayRowNum][indexPath.row]
        default : return
        }
        let vc = WriteViewController()
        vc.realmEvent = event
        vc.afterDissmiss = dismissHandler
        let navi = UINavigationController(rootViewController: vc)
        present(navi , animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.tag == -1 { return }
        guard let layout = collectionViewLayout else { return }
        // collectionView의 item에 마진이 있기 때문에, item의 width와 item 사이의 간격을 포함한 offset에서 left Inset을 뺸 만큼 스크롤
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                         y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
