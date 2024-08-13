import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FSCalendar

class CalendarViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let calendarView = CalendarView()
    
    init(with reactor: CalendarReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.reactor?.action.onNext(.loadEvents)
        self.setNavigationbar()
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
    
    private func setNavigationbar() {
        self.title = "달력으로 보기"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension CalendarViewController {
    func bind(reactor: CalendarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CalendarReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.leftButton.rx.tap
            .map { Reactor.Action.changeMonth(-1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rightButton.rx.tap
            .map { Reactor.Action.changeMonth(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.allAmountButton.rx.tap
            .map { Reactor.Action.filterEvents(.all) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.receivedAmountButton.rx.tap
            .map { Reactor.Action.filterEvents(.received) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.spentAmountButton.rx.tap
            .map { Reactor.Action.filterEvents(.spent) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CalendarReactor){
        reactor.state.map{ $0.amountFilterType }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] type in
                self?.calendarView.updateButtonStates(for: type)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.yearMonth.toString(format: "yyyy.MM") }
            .bind(to: calendarView.yearMonthButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.yearMonth }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newDate in
                self?.calendarView.calendar.setCurrentPage(newDate, animated: true)
                self?.calendarView.calendar.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.eventsByDate }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.calendarView.calendar.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedDateEvents }
            .distinctUntilChanged()
            .bind(to: self.calendarView.selectDateInCalendarView.eventSummaryTableView.rx.items(cellIdentifier: "EventSummaryTableViewCell", cellType: EventSummaryTableViewCell.self)) { index, event, cell in
                
                cell.configure(with: event)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.selectedDateLabelText }
            .distinctUntilChanged()
            .bind(to: self.calendarView.selectDateInCalendarView.selectedDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.selectedDate }
            .bind(onNext: { [weak self] date in
                guard let date = date else {
                    self?.calendarView.selectDateInCalendarView.isHidden = true
                    return
                }
                if let events = reactor.currentState.eventsByDate[date]{
                    self?.calendarView.selectDateInCalendarView.isHidden = false
                    self?.calendarView.selectDateInCalendarView.setRealAllAmountLabel(events: events)
                }
                else {
                    self?.calendarView.selectDateInCalendarView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return reactor?.currentState.eventsByDate[date]?.count ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .current {
            self.reactor?.action.onNext(.selectDate(date))
        }
    }
}
