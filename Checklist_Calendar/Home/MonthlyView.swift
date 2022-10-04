//
//  MonthlyView.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/13.
//

import UIKit
import FSCalendar

class MonthlyView: BaseView {
    
    let calendar = FSCalendar()
    
    private lazy var prevButton: UIButton = {
        let view = UIButton()
        view.setTitle(nil, for: .normal)
        view.setImage(UIImage(systemName: "chevron.compact.left"), for: .normal)
        view.tintColor = .textColor
        view.addTarget(self, action: #selector(prevBtnClicked), for: .touchUpInside)
        view.imageEdgeInsets = .init(top: 5, left: 0, bottom: 6.5, right: -8)
        return view
    }()
    
    lazy var titleButton: UIButton = {
        let view = UIButton()
        view.setTitle(self.calendar.currentPage.toString(format: "yyyy년 MM월"), for: .normal)
        view.setTitleColor(.textColor, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 15.8)
        return view
    }()
    
    private lazy var nextButton: UIButton = {
       let view = UIButton()
        view.setTitle(nil, for: .normal)
        view.setImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
        view.tintColor = .textColor
        view.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        view.imageEdgeInsets = .init(top: 5, left:  -8, bottom: 6.5, right: 0)
        return view
    }()
  
    
    lazy var calHeaderView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [prevButton, titleButton, nextButton])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    let todayBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("오늘", for: .normal)
        btn.setImage(UIImage(named: "cherry"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.textColor, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        btn.contentHorizontalAlignment = .center
        btn.semanticContentAttribute = .forceRightToLeft //<- 중요
        btn.imageEdgeInsets = .init(top: 15, left: 15.5, bottom: 16, right: 15.5) //<- 중요
        return btn
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .grouped)
        view.backgroundColor = .tableBgColor
        view.separatorColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setCalendarUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [calHeaderView, todayBtn, calendar, tableView].forEach { v in addSubview(v) }
        self.backgroundColor = .tableBgColor // TODO: 배경색 수정 필요
    }
    
    override func setConstraints() {
        
        prevButton.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        titleButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        
        calHeaderView.snp.makeConstraints { make in
            make.topMargin.equalTo(6)
            make.width.equalTo(134)
            make.height.equalTo(38)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(2)
        }
        
        todayBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(48)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(4.5)
            make.centerY.equalTo(calHeaderView)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(calHeaderView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()//(self.safeAreaLayoutGuide)
            
            if UIDevice.current.model.hasPrefix("iPad") {
                make.height.equalTo(350)
            } else {
                make.height.equalTo(282)
            }
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func changeCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        guard let currentDate = cal.date(byAdding: dateComponents, to: calendar.currentPage) else { return }
        self.calendar.setCurrentPage(currentDate, animated: true)
    }
    
    @objc func prevBtnClicked() {
        changeCurrentPage(isPrev: true)
    }
    
    @objc func nextBtnClicked() {
        changeCurrentPage(isPrev: false)
    }
    
    func setCalendarUI() {
        // calendar locale > 한국으로 설정
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 상단 요일을 한글로 변경
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
       
        // 월 ~ 일 요일 글자색 변경
        calendar.appearance.weekdayTextColor = .textColor.withAlphaComponent(0.8) //.black.withAlphaComponent(0.66)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 10.6)
        
        // 토,일 날짜 색상
//        calendar.appearance.titleWeekendColor = .systemRed.withAlphaComponent(0.7)
           
        // 기본 날짜 색상
        calendar.appearance.titleDefaultColor = .textColor
        calendar.appearance.titleSelectionColor = .selectTextColor
        
        // 숫자들 글자 폰트 사이즈 지정
        calendar.appearance.titleFont = .systemFont(ofSize: 13.2)
        
        // 캘린더 스크롤 가능하게 지정
        calendar.scrollEnabled = true
        // 캘린더 스크롤 방향 지정
        calendar.scrollDirection = .horizontal
        
        calendar.headerHeight = 0 // 헤더 높이 조정
        calendar.calendarHeaderView.isHidden = true // 헤더 숨기기
        
        calendar.appearance.calendar.rowHeight = 15
        
        // 양옆 년도, 월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 달에 유효하지 않은 날짜의 색 지정
        calendar.appearance.titlePlaceholderColor = .systemGray4
        // 달에 유효하지않은 날짜 채우기 방식
        calendar.placeholderType = .fillHeadTail
        
        // Today
        calendar.appearance.todayColor = .clear  // Today에 표시되는 동그라미색
        calendar.appearance.todaySelectionColor = .systemRed.withAlphaComponent(0.9)
        calendar.appearance.titleTodayColor = .systemRed.withAlphaComponent(0.9)
       
        calendar.appearance.selectionColor = .selectColor
       
        calendar.appearance.eventDefaultColor = .textColor.withAlphaComponent(0.4)
        calendar.appearance.eventSelectionColor = .bgColor
        
        calendar.appearance.borderRadius = 0.9 // 1이면 원, 0이면 사각형
        calendar.appearance.eventOffset = CGPoint.init(x: 0, y: -9.5)
        calendar.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
