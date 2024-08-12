import ReactorKit
import RxCocoa
import RxFlow

class SelectDateReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    let eventDateRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, eventDateRelay: PublishRelay<String>) {
        self.eventUseCase = eventUseCase
        self.eventDateRelay = eventDateRelay
    }
    
    enum Action {
        case dismissButtonTapped
        case selectDateButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectDateButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
