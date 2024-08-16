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
        case dateSortButtonTapped
        case cntSortButtonTapped
        case hideSortView
        
        // 검색
        case updateSearchTextField(String)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadOthersEventSummary
        case loadFilteredOthersEventSummary(String)
    }
    
    enum Mutation {
        case setOthersEventSummary([EventSummary])
        case setSearchQuery(String)
        case setFilterOption(String)
        case setSortOption(EventSummarySortOption)
        case setSortViewHidden
    }
    
    struct State {
        var othersEventSummaries: [EventSummary] = []
        var searchQuery: String = ""
        var filterTitle: String = "필터"
        var sortOption: EventSummarySortOption = .date
        var sortTitle: String = "최신순"
        var isHiddenSortView: Bool = true
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
            self.steps.accept(EventHistoryStep.presentToEventRelationshipFilterViewController(filterRelay: filterRelay))
            return .empty()
        case .sortButtonTapped:
            return .just(.setSortViewHidden)
        case .dateSortButtonTapped:
            return self.eventUseCase.searchAndFilterOtherEventSummaries(filterRelationship: currentState.filterTitle, sortBy: .date)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortViewHidden),
                        .just(.setSortOption(.date)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
        case .cntSortButtonTapped:
            return self.eventUseCase.searchAndFilterOtherEventSummaries(filterRelationship: currentState.filterTitle, sortBy: .amount)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortViewHidden),
                        .just(.setSortOption(.amount)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
        case .hideSortView:
            return .just(.setSortViewHidden)
            
            // 검색
        case .updateSearchTextField(let query):
            return self.eventUseCase.searchAndFilterOtherEventSummaries(query: query, filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setOthersEventSummary($0) }
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadOthersEventSummary:
            return self.eventUseCase.searchAndFilterOtherEventSummaries(filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setOthersEventSummary($0) }
        case .loadFilteredOthersEventSummary(let filter):
            return self.eventUseCase.searchAndFilterOtherEventSummaries(query: currentState.searchQuery, filterRelationship: filter, sortBy: currentState.sortOption)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setFilterOption(filter)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setOthersEventSummary(let othersEventSummaries):
            newState.othersEventSummaries = othersEventSummaries
        case .setSearchQuery(let text):
            newState.searchQuery = text
        case .setFilterOption(let filter):
            newState.filterTitle = filter
        case .setSortOption(let sortOption):
            newState.sortOption = sortOption
            newState.sortTitle = (sortOption == .date) ? "최신순" : "금액순"
        case .setSortViewHidden:
            newState.isHiddenSortView = !currentState.isHiddenSortView
        }
        return newState
    }
}
