import ReactorKit
import RxCocoa
import RxFlow

class SelectEventTypeReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    let eventTypeRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, eventTypeRelay: PublishRelay<String>) {
        self.eventUseCase = eventUseCase
        self.eventTypeRelay = eventTypeRelay
    }
    
    enum Action {
        case dismissButtonTapped
        case selectEventButtonTapped
        case selectEventType(Int)
        case loadEventTypes
    }
    
    enum Mutation {
        case setEventTypes([EventType])
        case setSelectEventType(String)
        case setSelectButtonEnable(Bool)
    }
    
    struct State {
        var eventTypes: [EventType] = []
        var selectedEventType: String? = nil
        var isEnableSelectEventButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectEventButtonTapped:
            eventTypeRelay.accept(currentState.selectedEventType ?? "")
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
                    .setEventTypes(eventTypes)
                }
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
        }
        return newState
    }
}
