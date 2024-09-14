import ReactorKit
import RxCocoa
import RxFlow

class SelectEventTypeReactor: ReactorKit.Reactor, Stepper {
    var initialState: State
    var steps = PublishRelay<Step>()
    let eventUseCase: EventUseCase
    let eventLocalDBUseCase: EventLocalDBUseCase
    let eventTypeRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, eventLocalDBUseCase: EventLocalDBUseCase, eventTypeRelay: PublishRelay<String>, initialEventType: String?) {
        self.eventUseCase = eventUseCase
        self.eventLocalDBUseCase = eventLocalDBUseCase
        self.eventTypeRelay = eventTypeRelay
        if let initialEventType = initialEventType {
            self.initialState = State(selectedEventType: initialEventType)
        }
        else {
            self.initialState = State()
        }
    }
    
    enum Action {
        case dismissButtonTapped
        case selectEventButtonTapped
        case addNewEventTypeButtonTapped
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
        case .selectEventButtonTapped:
            eventTypeRelay.accept(currentState.selectedEventType ?? "")
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .addNewEventTypeButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            self.steps.accept(EventHistoryStep.navigateToAddNewEventTypeViewController)
            return .empty()
        case .selectEventType(let index):
            let selectedEventType = currentState.eventTypes[index].name
            return .concat([
                .just(.setSelectEventType(selectedEventType)),
                .just(.setSelectButtonEnable(true))
            ])
        case .loadEventTypes:
            return self.fetchEventTypes()
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
    
    private func fetchEventTypes() -> Observable<[EventType]> {
        if UserDefaultsManager.shared.isLoggedIn() {
            return self.eventUseCase.fetchEventTypes()
        } else {
            return self.eventLocalDBUseCase.fetchEventTypes()
        }
    }
}
