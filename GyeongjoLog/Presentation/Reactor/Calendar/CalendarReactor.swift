import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class CalendarReactor: Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    enum Action {
        case backButtonTapped
        case changeMonth(Int)
        case filterEvents(AmountFilterType)
        case selectDate(Date)
        case loadEvents
    }
    
    enum Mutation {
        case setEvents([Event])
        case setFilteredEvents([Event])
        case setAmountFilterType(AmountFilterType)
        case setYearMonth(Date)
        case setSelectedDate(Date?)
        case setSelectedDateEvents([Event])
    }
    
    struct State {
        var yearMonth: Date = Date()
        var events: [Event] = []
        var filteredEvents: [Event] = []
        var amountFilterType: AmountFilterType = .all
        var selectedDate: Date?
        var eventsByDate: [Date: [Event]] = [:]
        var selectedDateLabelText: String = ""
        var selectedDateEvents: [Event] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
            
        case .changeMonth(let value):
            let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentState.yearMonth)!
            return .concat([
                .just(.setYearMonth(newDate)),
                self.eventUseCase.fetchEvents(forMonth: newDate)
                    .map { .setEvents($0) }
            ])
        case .filterEvents(let amountType):
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
            let filteredEvents = currentState.filteredEvents.filter {
                Calendar.current.isDate($0.date.toDate(), inSameDayAs: date)
            }
            return .concat([
                .just(.setSelectedDate(date)),
                .just(.setSelectedDateEvents(filteredEvents))
            ])
        case .loadEvents:
            return self.eventUseCase.fetchEvents(forMonth: currentState.yearMonth)
                .map { .setEvents($0) }
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
}
