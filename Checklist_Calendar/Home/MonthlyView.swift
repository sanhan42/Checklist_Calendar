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
        view.setImage(UIImage(named: "icon_prev")?.withTintColor(.black.withAlphaComponent(0.9)), for: .normal)
        view.addTarget(self, action: #selector(prevBtnClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var titleButton: UIButton = {
        let view = UIButton()
        view.setTitle(self.calendar.currentPage.toString(), for: .normal)
        view.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
        return view
    }()
    
    private lazy var nextButton: UIButton = {
       let view = UIButton()
        view.setTitle(nil, for: .normal)
        view.setImage(UIImage(named: "icon_next")?.withTintColor(.black.withAlphaComponent(0.9)), for: .normal)
        view.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        return view
    }()
  
    
    lazy var calHeaderView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [prevButton, titleButton, nextButton])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .null, style: .grouped)
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
        [calHeaderView, calendar, tableView].forEach { v in addSubview(v) }
    
        self.backgroundColor = .systemBackground
    }
    
    override func setConstraints() {
        prevButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
        calHeaderView.snp.makeConstraints { make in
            make.topMargin.equalTo(12)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(48)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(calHeaderView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottomMargin.equalTo(0)
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
        calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.6)
        
        // 토,일 날짜 색상
        calendar.appearance.titleWeekendColor = .systemRed.withAlphaComponent(0.8)
        // 기본 날짜 색상
        calendar.appearance.titleDefaultColor = .black.withAlphaComponent(0.9)
        
        // 숫자들 글자 폰트 사이즈 지정
        self.calendar.appearance.titleFont = .systemFont(ofSize: 16)
        
        // 캘린더 스크롤 가능하게 지정
        calendar.scrollEnabled = true
        // 캘린더 스크롤 방향 지정
        calendar.scrollDirection = .horizontal
        
        calendar.headerHeight = 0 // 헤더 높이 조정
        calendar.calendarHeaderView.isHidden = true // 헤더 숨기기
        
        // 캘린더의 cornerRadius 지정
        calendar.layer.cornerRadius = 10
        
        // 양옆 년도, 월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 달에 유효하지 않은 날짜의 색 지정
        calendar.appearance.titlePlaceholderColor = .systemGray4
        // 달에 유효하지않은 날짜 채우기 방식
        calendar.placeholderType = .fillHeadTail
        
        // 캘린더 숫자와 subtitle간의 간격 조정
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
    }
    
}
