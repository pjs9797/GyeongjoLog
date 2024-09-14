import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class EnterAuthNumberForFindPWReactor: ReactorKit.Reactor, Stepper {
    var timerDisposeBag = DisposeBag()
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
        self.action.onNext(.startTimer)
        self.action.onNext(.reSendButtonTapped)
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
            return self.userUseCase.requestEmailAuthCode(email: UserDefaults.standard.string(forKey: "userEmail") ?? "")
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setTimer(300))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: FindPwStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .nextButtonTapped:
            return self.userUseCase.checkEmailAuthCode(email: UserDefaults.standard.string(forKey: "userEmail") ?? "", code: currentState.authNumber)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self?.steps.accept(FindPwStep.navigateToEnterPasswordForFindPWViewController)
                    }
                    else {
                        self?.steps.accept(FindPwStep.presentToDifferentCodeAlertController)
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: FindPwStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
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
