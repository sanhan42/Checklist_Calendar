//
//  MonthlyViewController.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import FSCalendar

class MonthlyViewController: BaseViewController {
    
    let mainView = MonthlyView()
    lazy var lunarDate: String = {
        let chineseCalendar = Calendar(identifier: .chinese)
        let formatter = DateFormatter()
        formatter.dateFormat = "음력 MM월 dd일"
        formatter.calendar = chineseCalendar
        let date = mainView.calendar.selectedDate ?? Date()
        return formatter.string(from: date)
    }()
    
    private var selectIndexPath: IndexPath?
    private var collectionViewLayout: UICollectionViewFlowLayout?
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.mainView.calendar, action: #selector(self.mainView.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.isNavigationBarHidden = true
        setToolbar()
        
        self.view = mainView
        mainView.calendar.dataSource = self
        mainView.calendar.delegate = self
        
        mainView.titleButton.addTarget(self, action: #selector(setDate), for: .touchUpInside)
        
        mainView.addGestureRecognizer(scopeGesture)
        mainView.tableView.panGestureRecognizer.require(toFail: scopeGesture)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MonthlyTableViewCell.self, forCellReuseIdentifier: MonthlyTableViewCell.reuseIdentifier)
    }
    
    @objc func setDate() {
        showDatePickerPopup { _ in
            self.mainView.titleButton.setTitle(self.datePicker.date.toString(format: "yyyy년 MM월"), for: .normal)
            self.mainView.calendar.select(self.datePicker.date, scrollToDate: true)
        }
    }
    
    func setToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.backgroundColor = .bgColor
        
        let btn = UIButton()
        btn.setTitle("새로운 일정 추가", for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor.textColor.withAlphaComponent(0.9).cgColor
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(addNewEventBtnClicked), for: .touchUpInside)
        let addNewEventBtn = UIBarButtonItem(customView: btn)
        toolbarItems = [addNewEventBtn]
    }
    
    @objc func addNewEventBtnClicked() {
        self.present(WriteViewController(), animated: true)
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
        //        mainView.calendar.removeConstraint(mainView.calendar.constraints.last!)
        mainView.calendar.snp.remakeConstraints { make in
            make.top.equalTo(mainView.calHeaderView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(bounds.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            // TODO: layoutIfNeeded 메서드 검색
        }
    }
    
    //    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    //    }
    //
}

extension MonthlyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MonthlyTableViewHeaderView()
        header.titleLabel.text = lunarDate
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO: 해당 날짜에 등록된 이벤드 시간 종류 개수로 수정하기
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyTableViewCell.reuseIdentifier, for: indexPath) as? MonthlyTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.row
            collectionViewLayout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            return cell
    }
}

extension MonthlyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCollectionViewCell.reuseIdentifier, for: indexPath) as? MonthlyCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
