import ReactorKit
import RxCocoa
import RxFlow

class MyEventSummaryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    var filterRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase, eventType: String, idList:[String]) {
        self.eventUseCase = eventUseCase
        self.initialState = State(eventType: eventType, idList: idList)
    }
    
    enum Action {
        // 네비게이션 버튼 탭
        case backButtonTapped
        case calendarButtonTapped
        case plusButtonTapped
        
        // 버튼 탭
        case filterButtonTapped
        case sortButtonTapped
        
        // 검색
        case updateSearchTextField(String)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadMyEventSummary
        case loadFilteredMyEventSummary(String)
    }
    
    enum Mutation {
        case setMyEventSummary([EventSummary])
        case setFilteredMyEventSummary([EventSummary])
        case setFilterTitle(String)
        case setSearchQuery(String)
    }
    
    struct State {
        var eventType: String
        var idList: [String]
        var myEventSummaries: [EventSummary] = []
        var filteredMyEventSummaries: [EventSummary] = []
        var amount: Int = 0
        var eventCnt: String = ""
        var filterTitle: String = "필터"
        var searchQuery: String = ""
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
            self.steps.accept(EventHistoryStep.navigateToAddEventViewController)
            return .empty()
            
            // 버튼 탭
        case .filterButtonTapped:
            self.steps.accept(EventHistoryStep.presentToEventRelationshipFilterViewController(filterRelay: filterRelay))
            return .empty()
        case .sortButtonTapped:
            return .empty()
            
            // 검색
        case .updateSearchTextField(let text):
            return .concat([
                .just(.setSearchQuery(text)),
                .just(.setFilteredMyEventSummary(filterAndSearchEvents(filter: currentState.filterTitle, query: text)))
            ])
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEventSummary:
            return self.eventUseCase.fetchMyEventSummaries(idList: currentState.idList)
                .map{ myEventSummaries in
                    return .setMyEventSummary(myEventSummaries)
                }
        case .loadFilteredMyEventSummary(let filter):
            return .concat([
                .just(.setFilterTitle(filter)),
                .just(.setFilteredMyEventSummary(filterAndSearchEvents(filter: filter, query: currentState.searchQuery)))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyEventSummary(let myEventSummaries):
            newState.myEventSummaries = myEventSummaries
            newState.filteredMyEventSummaries = myEventSummaries
            newState.amount = sumAllAmount(myEventSummaries: myEventSummaries)
            newState.eventCnt = "\(myEventSummaries.count)명의 내역입니다"
        case .setFilteredMyEventSummary(let filteredMyEventSummaries):
            newState.filteredMyEventSummaries = filteredMyEventSummaries
        case .setFilterTitle(let filter):
            newState.filterTitle = filter
        case .setSearchQuery(let text):
            newState.searchQuery = text
        }
        return newState
    }
    
    private func filterAndSearchEvents(filter: String, query: String) -> [EventSummary] {
        var results = currentState.myEventSummaries
        
        if filter != "필터" {
            results = results.filter { $0.relationship == filter }
        }
        
        if !query.isEmpty {
            results = results.filter { self.isMatch(summary: $0, query: query) }
        }
        
        return results
    }
    
    private func sumAllAmount(myEventSummaries: [EventSummary]) -> Int {
        var amount = 0
        for myEventSummary in myEventSummaries {
            amount += myEventSummary.amount
        }
        return amount
    }
    
    private func isMatch(summary: EventSummary, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        let formattedPhoneNumber = summary.phoneNumber.replacingOccurrences(of: "-", with: "")
        let lowercasedName = summary.name.lowercased()
        return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
    }
}
