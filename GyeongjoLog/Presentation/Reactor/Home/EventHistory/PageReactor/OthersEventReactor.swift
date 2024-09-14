import ReactorKit
import RxCocoa
import RxFlow

class OthersEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let eventUseCase: EventUseCase
    let eventLocalDBUseCase: EventLocalDBUseCase
    var filterRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase, eventLocalDBUseCase: EventLocalDBUseCase) {
        self.eventUseCase = eventUseCase
        self.eventLocalDBUseCase = eventLocalDBUseCase
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
        
        // 컬렉션뷰셀 탭
        case selectOthersEventSummary(Int)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadOthersEventSummary
        case loadFilteredOthersEventSummary(String)
    }
    
    enum Mutation {
        case setOthersEventSummary([Event])
        case setSearchQuery(String)
        case setFilterOption(String)
        case setSortOption(EventSummarySortOption)
        case setSortViewHidden
    }
    
    struct State {
        var othersEventSummaries: [Event] = []
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
            let currentFilterType = currentState.filterTitle == "필터" ? nil : currentState.filterTitle
            self.steps.accept(EventHistoryStep.presentToEventRelationshipFilterViewController(filterRelay: filterRelay, initialFilterType: currentFilterType))
            return .empty()
        case .sortButtonTapped:
            return .just(.setSortViewHidden)
        case .dateSortButtonTapped:
            return self.fetchOthersEvents(filterRelationship: currentState.filterTitle, sortBy: .date)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortViewHidden),
                        .just(.setSortOption(.date)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .cntSortButtonTapped:
            return self.fetchOthersEvents(filterRelationship: currentState.filterTitle, sortBy: .amount)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortViewHidden),
                        .just(.setSortOption(.amount)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .hideSortView:
            return .just(.setSortViewHidden)
            
            // 검색
        case .updateSearchTextField(let query):
            return self.fetchOthersEvents(query: query, filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setOthersEventSummary($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
            // 컬렉션뷰셀 탭
        case .selectOthersEventSummary(let index):
            self.steps.accept(EventHistoryStep.navigateToDetailEventViewController(addEventFlow: .othersEventSummary, event: currentState.othersEventSummaries[index]))
            return .empty()
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadOthersEventSummary:
            return self.fetchOthersEvents(filterRelationship: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setOthersEventSummary($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .loadFilteredOthersEventSummary(let filter):
            return self.fetchOthersEvents(query: currentState.searchQuery, filterRelationship: filter, sortBy: currentState.sortOption)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setFilterOption(filter)),
                        .just(.setOthersEventSummary(events))
                    ])
                }
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
    
    private func fetchOthersEvents(query: String? = nil, filterRelationship: String = "필터", sortBy: EventSummarySortOption = .date) -> Observable<[Event]> {
        if UserDefaultsManager.shared.isLoggedIn() {
            return self.eventUseCase.fetchOthersEventSummaries(query: query, filterRelationship: filterRelationship, sortBy: sortBy)
        } else {
            return eventLocalDBUseCase.searchAndFilterOtherEventSummaries(query: query, filterRelationship: filterRelationship, sortBy: sortBy)
        }
    }
}
