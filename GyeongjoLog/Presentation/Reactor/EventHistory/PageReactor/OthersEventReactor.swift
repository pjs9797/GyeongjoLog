import ReactorKit
import RxCocoa
import RxFlow

class OthersEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    var filterRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    enum Action {
        // 버튼 탭
        case filterButtonTapped
        case sortButtonTapped
        
        // 검색
        case updateSearchTextField(String)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadOthersEventSummary
        case loadFilteredOthersEventSummary(String)
    }
    
    enum Mutation {
        case setOthersEventSummary([EventSummary])
        case setFilteredEventSummaries([EventSummary])
        case setFilterTitle(String)
        case setSearchQuery(String)
    }
    
    struct State {
        var othersEventSummaries: [EventSummary] = []
        var filteredEventSummaries: [EventSummary] = []
        var filterTitle: String = "필터"
        var searchQuery: String = ""
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
                .just(.setFilteredEventSummaries(filterAndSearchEvents(filter: currentState.filterTitle, query: text)))
            ])
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadOthersEventSummary:
            return self.eventUseCase.fetchOtherEventSummaries()
                .map{ othersEventSummaries in
                    return .setOthersEventSummary(othersEventSummaries)
                }
        case .loadFilteredOthersEventSummary(let filter):
            return .concat([
                .just(.setFilterTitle(filter)),
                .just(.setFilteredEventSummaries(filterAndSearchEvents(filter: filter, query: currentState.searchQuery)))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setOthersEventSummary(let othersEventSummaries):
            newState.othersEventSummaries = othersEventSummaries
            newState.filteredEventSummaries = othersEventSummaries
        case .setFilteredEventSummaries(let filteredEventSummaries):
            newState.filteredEventSummaries = filteredEventSummaries
        case .setFilterTitle(let filter):
            newState.filterTitle = filter
        case .setSearchQuery(let text):
            newState.searchQuery = text
        }
        return newState
    }
    
    private func filterAndSearchEvents(filter: String, query: String) -> [EventSummary] {
        var results = currentState.othersEventSummaries
        
        if filter != "필터" {
            results = results.filter { $0.relationship == filter }
        }
        
        if !query.isEmpty {
            results = results.filter { self.isMatch(summary: $0, query: query) }
        }
        
        return results
    }
    
    private func isMatch(summary: EventSummary, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        let formattedPhoneNumber = summary.phoneNumber.replacingOccurrences(of: "-", with: "")
        let lowercasedName = summary.name.lowercased()
        return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
    }
}
