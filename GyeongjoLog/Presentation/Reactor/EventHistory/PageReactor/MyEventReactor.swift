import ReactorKit
import RxCocoa
import RxFlow

class MyEventReactor: ReactorKit.Reactor, Stepper {
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
        
        // 컬렉션뷰 셀 탭
        case selectMyEvent(Int)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadMyEvent
        case loadFilteredMyEvent(String)
    }
    
    enum Mutation {
        case setMyEvent([MyEvent])
        case setFilteredMyEvent([MyEvent])
        case setFilterTitle(String)
    }
    
    struct State {
        var myEvents: [MyEvent] = []
        var filteredMyEvents: [MyEvent] = []
        var filterTitle: String = "필터"
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
            self.steps.accept(EventHistoryStep.presentToEventTypeFilterViewController(filterRelay: self.filterRelay))
            return .empty()
        case .sortButtonTapped:
            return .empty()
            
            // 컬렉션뷰 셀 탭
        case .selectMyEvent(let index):
            self.steps.accept(EventHistoryStep.navigateToMyEventSummaryViewController(eventType: currentState.myEvents[index].eventType, idList: currentState.myEvents[index].idList))
            return .empty()
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEvent:
            return self.eventUseCase.fetchMyEvents()
                .map{ myEvents in
                    return .setMyEvent(myEvents)
                }
        case .loadFilteredMyEvent(let filter):
            if filter == "필터"{
                return .concat([
                    .just(.setFilterTitle("필터")),
                    .just(.setFilteredMyEvent(currentState.myEvents))
                ])
            }
            else {
                let filteredEvents = currentState.myEvents.filter { $0.eventType == filter }
                return .concat([
                    .just(.setFilterTitle(filter)),
                    .just(.setFilteredMyEvent(filteredEvents))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyEvent(let myEvents):
            newState.myEvents = myEvents
            newState.filteredMyEvents = myEvents
        case .setFilteredMyEvent(let filteredEvents):
            newState.filteredMyEvents = filteredEvents
        case .setFilterTitle(let filter):
            newState.filterTitle = filter
        }
        return newState
    }
}

