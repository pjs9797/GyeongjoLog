import ReactorKit
import RxCocoa
import RxFlow

class AddNewEventTypeReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventLocalDBUseCase: EventLocalDBUseCase
    var filterRelay = PublishRelay<String>()
    
    init(eventLocalDBUseCase: EventLocalDBUseCase) {
        self.eventLocalDBUseCase = eventLocalDBUseCase
    }
    
    enum Action {
        // 버튼 탭
        case backButtonTapped
        case clearButtonTapped
        case addEventTypeButtonTapped
        
        // 텍스트 필드 입력
        case inputEventNameText(String)
        
        // 컬렉션뷰 셀 탭
        case selectColor(Int)
    }
    
    enum Mutation {
        case setEventNameText(String)
        case setNameLength(String)
        case setSelectColor(String)
        case setEnableAddEventNameButton
    }
    
    struct State {
        var colors: [String] = ["RedCustom", "OrangeCustom", "YellowCustom", "LightPink", "PinkCustom", "LightPurple", "PurpleCustom", "LightGreen", "GreenCustom", "Blue-Green", "Blue-Selection", "SkyBlue", "CobaltBlue", "BlackCustom", "LightGray-Selection", "Gray-Select"]
        var eventNameText: String = ""
        var nameLength: String = ""
        var selectedColor: String = ""
        var isEnableAddEventNameButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
        case .clearButtonTapped:
            return .concat([
                .just(.setEventNameText("")),
                .just(.setNameLength("0/20")),
                .just(.setEnableAddEventNameButton)
            ])
        case .addEventTypeButtonTapped:
            return self.eventLocalDBUseCase.updateEventType(eventType: currentState.eventNameText, color: currentState.selectedColor)
                .andThen(Completable.create { completable in
                    self.steps.accept(EventHistoryStep.popViewController)
                    completable(.completed)
                    return Disposables.create()
                })
                .andThen(.empty())
            
            // 텍스트 필드 입력
        case .inputEventNameText(let text):
            let nameLength = text.count
            return .concat([
                .just(.setEventNameText(text)),
                .just(.setNameLength("\(nameLength)/20")),
                .just(.setEnableAddEventNameButton)
            ])
            
            // 컬렉션뷰 셀 탭
        case .selectColor(let index):
            return .concat([
                .just(.setSelectColor(currentState.colors[index])),
                .just(.setEnableAddEventNameButton)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEventNameText(let text):
            newState.eventNameText = text
        case .setNameLength(let nameLength):
            newState.nameLength = nameLength
        case .setSelectColor(let color):
            newState.selectedColor = color
        case .setEnableAddEventNameButton:
            newState.isEnableAddEventNameButton = currentState.eventNameText != "" &&
            currentState.selectedColor != ""
        }
        return newState
    }
}

