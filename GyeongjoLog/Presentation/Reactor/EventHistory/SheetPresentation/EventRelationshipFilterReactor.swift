import ReactorKit
import RxCocoa
import RxFlow

class EventRelationshipFilterReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    let filterRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, filterRelay: PublishRelay<String>) {
        self.eventUseCase = eventUseCase
        self.filterRelay = filterRelay
    }
    
    enum Action {
        case dismissButtonTapped
        case resetButtonTapped
        case selectRelationshipButtonTapped
        case selectRelationship(Int)
    }
    
    enum Mutation {
        case setSelectRelationship(String)
        case setSelectButtonEnable(Bool)
    }
    
    struct State {
        var relationships: [String] = ["가족","친구","직장","연인","이웃","지인"]
        var selectedRelationship: String? = nil
        var isEnableSelectRelationshipButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .resetButtonTapped:
            filterRelay.accept("필터")
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectRelationshipButtonTapped:
            filterRelay.accept(currentState.selectedRelationship ?? "")
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectRelationship(let index):
            let selectedRelationship = currentState.relationships[index]
            return .concat([
                .just(.setSelectRelationship(selectedRelationship)),
                .just(.setSelectButtonEnable(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectRelationship(let relationship):
            newState.selectedRelationship = relationship
        case .setSelectButtonEnable(let isEnable):
            newState.isEnableSelectRelationshipButton = isEnable
        }
        return newState
    }
}
