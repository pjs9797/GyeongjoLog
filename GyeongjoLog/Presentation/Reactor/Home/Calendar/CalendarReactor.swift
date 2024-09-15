import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class CalendarReactor: Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let eventUseCase: EventUseCase
    let eventLocalDBUseCase: EventLocalDBUseCase
    var calendarDateRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase, eventLocalDBUseCase: EventLocalDBUseCase) {
        self.eventUseCase = eventUseCase
        self.eventLocalDBUseCase = eventLocalDBUseCase
    }
    
    enum Action {
        // 네비게이션 버튼
        case backButtonTapped
        
        // 달력 양 옆 버튼
        case changeMonth(Int)
        
        // 캘린더 연월 선택
        case yearMonthButtonTapped
        case setYearMonth(Date)
        
        // 전체, 받은, 보낸 금액 버튼
        case filterEvents(AmountFilterType)
        
        // 날짜 선택
        case selectDate(Date)
        
        // 초기 데이터
        case loadEvents
    }
    
    enum Mutation {
        // 데이터
        case setEvents([Event])
        case setFilteredEvents([Event])
        
        // 전체, 받은, 보낸 금액 버튼
        case setAmountFilterType(AmountFilterType)
        
        // 날짜 설정
        case setYearMonth(Date)
        case setSelectedDate(Date?)
        
        // 선택한 날짜에 대한 이벤트
        case setSelectedDateEvents([Event])
    }
    
    struct State {
        // 연도 월 라벨
        var yearMonth: Date = Date()
        
        // 데이터
        var events: [Event] = []
        var filteredEvents: [Event] = []
        
        // 전체, 받은, 보낸 금액 버튼
        var amountFilterType: AmountFilterType = .all
        
        // 날짜 설정
        var selectedDate: Date?
        var selectedDateLabelText: String = ""
        
        // 해당 월에 대한 모든 데이터
        var eventsByDate: [Date: [Event]] = [:]
        
        // 선택한 날짜에 대한 데이터
        var selectedDateEvents: [Event] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
            
        case .yearMonthButtonTapped:
            self.steps.accept(EventHistoryStep.presentToSelectCalendarDateViewController(eventDateRelay: self.calendarDateRelay, initialDate: currentState.yearMonth.toString(format: "yyyy.MM")))
            return .empty()
            
        case .setYearMonth(let date):
            return .just(.setYearMonth(date))
            
        case .changeMonth(let value):
            let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentState.yearMonth)!
            return .concat([
                .just(.setYearMonth(newDate)),
                self.fetchEventsForMonth(date: newDate)
                    .map { .setEvents($0) }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            ])
        case .filterEvents(let amountType):
            // 버튼을 탭했을 때 이미 선택되어있는 날짜에 대한 이벤트
            let filteredEvents = filterEvents(amountType, events: currentState.events)
            let selectedDateEvents = currentState.selectedDate.flatMap { date in
                filterEvents(amountType, events: filteredEvents.filter {
                    Calendar.current.isDate($0.date.toDate(), inSameDayAs: date)
                })
            } ?? []
            
            return .concat([
                .just(.setAmountFilterType(amountType)),
                .just(.setFilteredEvents(filteredEvents)),
                .just(.setSelectedDateEvents(selectedDateEvents))
            ])
        case .selectDate(let date):
            // 선택한 날짜에 대한 이벤트
            let filteredEvents = currentState.filteredEvents.filter {
                Calendar.current.isDate($0.date.toDate(), inSameDayAs: date)
            }
            return .concat([
                .just(.setSelectedDate(date)),
                .just(.setSelectedDateEvents(filteredEvents))
            ])
        case .loadEvents:
            return self.fetchEventsForMonth(date: currentState.yearMonth)
                .map { .setEvents($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEvents(let events):
            newState.events = events
            newState.filteredEvents = filterEvents(.all, events: events)
            newState.eventsByDate = calculateEventByDate(events)
        case .setFilteredEvents(let filteredEvents):
            newState.filteredEvents = filteredEvents
            newState.eventsByDate = calculateEventByDate(filteredEvents)
        case .setAmountFilterType(let type):
            newState.amountFilterType = type
        case .setYearMonth(let date):
            newState.yearMonth = date
        case .setSelectedDate(let date):
            newState.selectedDate = date
            newState.selectedDateLabelText = self.formatDate(date: date ?? Date())
        case .setSelectedDateEvents(let selectedDateEvents):
            newState.selectedDateEvents = selectedDateEvents
        }
        return newState
    }
    
    private func filterEvents(_ filterType: AmountFilterType, events: [Event]) -> [Event] {
        return events.filter { event in
            switch filterType {
            case .all:
                return true
            case .received:
                return event.amount > 0
            case .spent:
                return event.amount < 0
            }
        }
    }
    
    // 월에 대한 모든 이벤트 가져옴
    private func calculateEventByDate(_ events: [Event]) -> [Date: [Event]] {
        var eventAmounts: [Date: [Event]] = [:]
        let calendar = Calendar.current
        
        for event in events {
            let eventDate = event.date.toDate()
            let dayStart = calendar.startOfDay(for: eventDate)
            
            if eventAmounts[dayStart] != nil {
                eventAmounts[dayStart]?.append(event)
            } else {
                eventAmounts[dayStart] = [event]
            }
        }
        
        return eventAmounts
    }
    
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    private func fetchEventsForMonth(date: Date) -> Observable<[Event]> {
        if UserDefaultsManager.shared.isLoggedIn() {
            return eventUseCase.fetchCalendarEvents(forMonth: date.toString(format: "yyyy.MM"))
        } else {
            return eventLocalDBUseCase.fetchEvents(forMonth: date)
        }
    }
}
