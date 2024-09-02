import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class EnterAuthNumberForFindPWReactor: ReactorKit.Reactor, Stepper {
    var timerDisposeBag = DisposeBag()
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    init(){
        self.action.onNext(.startTimer)
    }
    
    enum Action {
        case backButtonTapped
        
        case authNumberTextFieldTapped
        case inputAuthNumberText(String)
        case reSendButtonTapped
        case nextButtonTapped
        
        case startTimer
    }
    
    enum Mutation {
        case setEditingAuthNumberTextFieldView(Bool)
        case setAuthNumberText(String)
        case setIsEnableNextButton(Bool)
        case setTimer(Int)
    }
    
    struct State {
        var isEditingAuthNumberTextFieldView: Bool = false
        var authNumber: String = ""
        var remainingSeconds: Int = 300
        var isEnableNextButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AppStep.popViewController)
            return .empty()
            
        case .authNumberTextFieldTapped:
            return .just(.setEditingAuthNumberTextFieldView(true))
        case .inputAuthNumberText(let number):
            let isValidAuthNumber = number.count == 6
            return Observable.concat([
                .just(.setAuthNumberText(number)),
                .just(.setIsEnableNextButton(isValidAuthNumber))
            ])
        case .reSendButtonTapped:
            //TODO: 인증번호 post
            return .just(.setTimer(300))
        case .nextButtonTapped:
            self.steps.accept(AppStep.navigateToEnterPasswordForFindPWViewController)
            return .empty()
        case .startTimer:
            timerDisposeBag = DisposeBag()
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .take(while: { [weak self] _ in self?.currentState.remainingSeconds ?? 0 > 0 })
                .map { [weak self] _ in .setTimer((self?.currentState.remainingSeconds ?? 1) - 1) }
                .do(onDispose: { [weak self] in
                    self?.timerDisposeBag = DisposeBag()
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEditingAuthNumberTextFieldView(let isEditing):
            newState.isEditingAuthNumberTextFieldView = isEditing
        case .setAuthNumberText(let number):
            newState.authNumber = number
        case .setIsEnableNextButton(let isEnable):
            newState.isEnableNextButton = isEnable
        case .setTimer(let seconds):
            newState.remainingSeconds = seconds
        }
        return newState
    }
}
