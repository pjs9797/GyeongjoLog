import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class HistoryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    enum Action {
        // 버튼 탭
        case calendarButtonTapped
        case plusButtonTapped
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
        case .calendarButtonTapped:
            return .empty()
        case .plusButtonTapped:
            return .empty()
        case .filterButtonTapped:
            return .empty()
        case .sortButtonTapped:
            return .empty()
            // 컬렉션뷰 셀 탭
        case .selectMyEvent(let index):
            return .empty()
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEvent:
            return self.eventUseCase.fetchMyEvents()
                .map{ myEvents in
                    .setMyEvent(myEvents)
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
