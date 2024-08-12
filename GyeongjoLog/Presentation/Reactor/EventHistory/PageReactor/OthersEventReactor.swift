import ReactorKit
import RxCocoa
import RxFlow

class OthersEventReactor: ReactorKit.Reactor, Stepper {
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
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadOthersEventSummary
    }
    
    enum Mutation {
        case setOthersEventSummary([EventSummary])
    }
    
    struct State {
        var othersEventSummaries: [EventSummary] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
            return .empty()
        case .sortButtonTapped:
            return .empty()
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadOthersEventSummary:
            return self.eventUseCase.fetchOtherEventSummaries()
                .map{ othersEventSummaries in
                    return .setOthersEventSummary(othersEventSummaries)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setOthersEventSummary(let othersEventSummaries):
            newState.othersEventSummaries = othersEventSummaries
        }
        return newState
    }
}
