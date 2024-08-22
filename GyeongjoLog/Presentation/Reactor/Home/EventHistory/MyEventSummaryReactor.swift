import ReactorKit
import RxCocoa
import RxFlow

class MyEventSummaryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    var filterRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase, eventType: String, date: String) {
        self.eventUseCase = eventUseCase
        self.initialState = State(eventType: eventType, date: date)
    }
    
    enum Action {
        // 네비게이션 버튼 탭
        case backButtonTapped
        case calendarButtonTapped
        case plusButtonTapped
        case hideSortView
        
        // 버튼 탭
        case filterButtonTapped
        case sortButtonTapped
        case dateSortButtonTapped
        case cntSortButtonTapped
        
        // 검색
        case updateSearchTextField(String)
        
        // 컬렉션뷰셀 탭
        case selectMyEventSummary(Int)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadMyEventSummary
        case loadFilteredMyEventSummary(String)
    }
    
    enum Mutation {
        case setMyEventSummary([Event])
        case setFilteredMyEventSummary([Event])
        case setSearchQuery(String)
        case setFilterOption(String)
        case setSortOption(EventSummarySortOption)
        case setSortViewHidden
    }
    
    struct State {
        var eventType: String
        var date: String
        var myEventSummaries: [Event] = []
        var filteredMyEventSummary: [Event] = []
        var amount: Int = 0
        var eventCnt: String = ""
        var searchQuery: String = ""
        var filterTitle: String = "필터"
        var sortOption: EventSummarySortOption = .date
        var sortTitle: String = "최신순"
        var isHiddenSortView: Bool = true
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 네비게이션 버튼 탭
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
        case .calendarButtonTapped:
            self.steps.accept(EventHistoryStep.navigateToCalendarViewController)
            return .empty()
        case .plusButtonTapped:
            self.steps.accept(EventHistoryStep.navigateToAddMyEventSummaryViewController(eventType: currentState.eventType, date: currentState.myEventSummaries[0].date))
            return .empty()
            
            // 버튼 탭
        case .filterButtonTapped:
            let currentFilterType = currentState.filterTitle == "필터" ? nil : currentState.filterTitle
            self.steps.accept(EventHistoryStep.presentToEventRelationshipFilterViewController(filterRelay: filterRelay, initialFilterType: currentFilterType))
            return .empty()
        case .sortButtonTapped:
            return .just(.setSortViewHidden)
        case .dateSortButtonTapped:
            return self.eventUseCase.fetchMyEventSummaries(eventType: currentState.eventType, date: currentState.date, filterRelationship: currentState.filterTitle, sortBy: .date)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortOption(.date)),
                        .just(.setFilteredMyEventSummary(events))
                    ])
                }
        case .cntSortButtonTapped:
            return self.eventUseCase.fetchMyEventSummaries(eventType: currentState.eventType, date: currentState.date, filterRelationship: currentState.filterTitle, sortBy: .amount)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortOption(.amount)),
                        .just(.setFilteredMyEventSummary(events))
                    ])
                }
        case .hideSortView:
            return .just(.setSortViewHidden)
            
            // 검색
        case .updateSearchTextField(let query):
            return self.eventUseCase.fetchMyEventSummaries(eventType: currentState.eventType, date: currentState.date, query: query, filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setFilteredMyEventSummary($0) }
            
            // 컬렉션뷰셀 탭
        case .selectMyEventSummary(let index):
            self.steps.accept(EventHistoryStep.navigateToDetailEventViewController(addEventFlow: .myEventSummary, event: currentState.myEventSummaries[index]))
            return .empty()
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEventSummary:
            return self.eventUseCase.fetchMyEventSummaries(eventType: currentState.eventType, date: currentState.date, filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setMyEventSummary($0) }
        case .loadFilteredMyEventSummary(let filter):
            return self.eventUseCase.fetchMyEventSummaries(eventType: currentState.eventType, date: currentState.date, query: currentState.searchQuery, filterRelationship: filter, sortBy: currentState.sortOption)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setFilterOption(filter)),
                        .just(.setFilteredMyEventSummary(events))
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyEventSummary(let myEventSummaries):
            newState.myEventSummaries = myEventSummaries
            newState.filteredMyEventSummary = myEventSummaries
            newState.amount = sumAllAmount(myEventSummaries: myEventSummaries)
            newState.eventCnt = "\(myEventSummaries.count)명의 내역입니다"
        case .setFilteredMyEventSummary(let filteredMyEventSummaries):
            newState.filteredMyEventSummary = filteredMyEventSummaries
        case .setSearchQuery(let text):
            newState.searchQuery = text
        case .setFilterOption(let filter):
            newState.filterTitle = filter
        case .setSortOption(let sortOption):
            newState.sortOption = sortOption
            newState.sortTitle = (sortOption == .date) ? "최신순" : "금액순"
        case .setSortViewHidden:
            newState.isHiddenSortView = !newState.isHiddenSortView
        }
        return newState
    }
    
    private func sumAllAmount(myEventSummaries: [Event]) -> Int {
        var amount = 0
        for myEventSummary in myEventSummaries {
            amount += myEventSummary.amount
        }
        return amount
    }
}
