import ReactorKit
import RxCocoa
import RxFlow

class MyEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    
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
    }
    
    enum Mutation {
        case setMyEvent([MyEvent])
    }
    
    struct State {
        var myEvents: [MyEvent] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyEvent(let myEvents):
            newState.myEvents = myEvents
        }
        return newState
    }
}
