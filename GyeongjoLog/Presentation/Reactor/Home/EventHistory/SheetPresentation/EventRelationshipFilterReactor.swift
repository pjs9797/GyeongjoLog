import ReactorKit
import RxCocoa
import RxFlow

class EventRelationshipFilterReactor: ReactorKit.Reactor, Stepper {
    var initialState: State
    var steps = PublishRelay<Step>()
    private let eventLocalDBUseCase: EventLocalDBUseCase
    let filterRelay: PublishRelay<String>
    
    init(eventLocalDBUseCase: EventLocalDBUseCase, filterRelay: PublishRelay<String>, initialFilterType: String?) {
        self.eventLocalDBUseCase = eventLocalDBUseCase
        self.filterRelay = filterRelay
        if let initialFilterType = initialFilterType {
            self.initialState = State(
                relationships: ["가족", "친구", "직장", "연인", "이웃", "지인"],
                selectedRelationship: initialFilterType,
                isEnableSelectRelationshipButton: true
            )
        } 
        else {
            self.initialState = State(
                relationships: ["가족", "친구", "직장", "연인", "이웃", "지인"],
                selectedRelationship: nil,
                isEnableSelectRelationshipButton: false
            )
        }
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
