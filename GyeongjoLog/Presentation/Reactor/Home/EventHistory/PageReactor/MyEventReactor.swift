import ReactorKit
import RxCocoa
import RxFlow

class MyEventReactor: ReactorKit.Reactor, Stepper {
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
        
        // 컬렉션뷰 셀 탭
        case selectMyEvent(Int)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadMyEvent
        case loadFilteredMyEvent(String)
    }
    
    enum Mutation {
        case setMyEvent([MyEvent])
        case setFilterOption(String)
        case setSortOption(MyEventSortOption)
        case setSortViewHidden
    }
    
    struct State {
        var myEvents: [MyEvent] = []
        var filterTitle: String = "필터"
        var sortOption: MyEventSortOption = .date
        var sortTitle: String = "최신순"
        var isHiddenSortView: Bool = true
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
            let currentFilterType = currentState.filterTitle == "필터" ? nil : currentState.filterTitle
            self.steps.accept(EventHistoryStep.presentToEventTypeFilterViewController(filterRelay: self.filterRelay, initialFilterType: currentFilterType))
            return .empty()
        case .sortButtonTapped:
            return .just(.setSortViewHidden)
        case .dateSortButtonTapped:
            return self.fetchMyEvents(filter: currentState.filterTitle, sortBy: .date)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortOption(.date)),
                        .just(.setMyEvent(events))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .cntSortButtonTapped:
            return self.fetchMyEvents(filter: currentState.filterTitle, sortBy: .eventCnt)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setSortOption(.eventCnt)),
                        .just(.setMyEvent(events))
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
            
            // 컬렉션뷰 셀 탭
        case .selectMyEvent(let index):
            self.steps.accept(EventHistoryStep.navigateToMyEventSummaryViewController(eventType: currentState.myEvents[index].eventType, date: currentState.myEvents[index].date))
            return .empty()
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEvent:
            return self.fetchMyEvents(filter: currentState.filterTitle, sortBy: currentState.sortOption)
                .map { .setMyEvent($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .loadFilteredMyEvent(let filter):
            return self.fetchMyEvents(filter: filter, sortBy: currentState.sortOption)
                .flatMap { events in
                    return Observable.concat([
                        .just(.setFilterOption(filter)),
                        .just(.setMyEvent(events))
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
        case .setMyEvent(let myEvents):
            newState.myEvents = myEvents
        case .setFilterOption(let filter):
            newState.filterTitle = filter
        case .setSortViewHidden:
            newState.isHiddenSortView = !currentState.isHiddenSortView
        case .setSortOption(let sortOption):
            newState.sortOption = sortOption
            newState.sortTitle = (sortOption == .date) ? "최신순" : "건수"
        }
        return newState
    }
    
    private func fetchMyEvents(filter: String = "필터", sortBy: MyEventSortOption = .date) -> Observable<[MyEvent]> {
        if UserDefaultsManager.shared.isLoggedIn() {
            return self.eventUseCase.fetchMyEvents(filterEventType: filter, sortBy: sortBy)
        } else {
            return self.eventLocalDBUseCase.fetchMyEvents(filterEventType: filter, sortBy: sortBy)
        }
    }
}

