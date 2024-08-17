import ReactorKit
import RxCocoa
import RxFlow

class EventTypeFilterReactor: ReactorKit.Reactor, Stepper {
    var initialState: State
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    let filterRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, filterRelay: PublishRelay<String>, initialFilterType: String?) {
        self.eventUseCase = eventUseCase
        self.filterRelay = filterRelay
        if let initialFilterType = initialFilterType {
            self.initialState = State(selectedEventType: initialFilterType)
        }
        else {
            self.initialState = State()
        }
    }
    
    enum Action {
        case dismissButtonTapped
        case resetButtonTapped
        case selectEventButtonTapped
        case selectEventType(Int)
        case loadEventTypes
    }
    
    enum Mutation {
        case setEventTypes([EventType])
        case setSelectEventType(String)
        case setSelectButtonEnable(Bool)
        case selectEventTypeAtIndex(Int)
    }
    
    struct State {
        var eventTypes: [EventType] = []
        var selectedEventType: String? = nil
        var selectedIndex: Int? = nil
        var isEnableSelectEventButton: Bool = false
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
        case .selectEventButtonTapped:
            filterRelay.accept(currentState.selectedEventType ?? "")
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectEventType(let index):
            let selectedEventType = currentState.eventTypes[index].name
            return .concat([
                .just(.setSelectEventType(selectedEventType)),
                .just(.setSelectButtonEnable(true))
            ])
        case .loadEventTypes:
            return self.eventUseCase.fetchEventTypes()
                .map { eventTypes in
                    var mutations: [Mutation] = [.setEventTypes(eventTypes)]
                    if let initialEventType = self.currentState.selectedEventType,
                       let selectedIndex = eventTypes.firstIndex(where: { $0.name == initialEventType }) {
                        mutations.append(.selectEventTypeAtIndex(selectedIndex))
                        mutations.append(.setSelectButtonEnable(true))
                    }
                    return mutations
                }
                .flatMap { Observable.from($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEventTypes(let eventTypes):
            newState.eventTypes = eventTypes
        case .setSelectEventType(let type):
            newState.selectedEventType = type
        case .setSelectButtonEnable(let isEnable):
            newState.isEnableSelectEventButton = isEnable
        case .selectEventTypeAtIndex(let index):
            newState.selectedIndex = index
        }
        return newState
    }
}
