import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class EnterEmailForSignupReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
    }
    
    enum Action {
        case backButtonTapped
        
        case emailTextFieldTapped
        case inputEmailText(String)
        
        case nextButtonTapped
    }
    
    enum Mutation {
        case setEditingEmailTextFieldView(Bool)
        case setEmailText(String)
        case setIsEnableNextButton(Bool)
    }
    
    struct State {
        var isEditingEmailTextFieldView: Bool = false
        
        var email: String = ""
        var isEnableNextButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.popViewController)
            return .empty()
            
        case .emailTextFieldTapped:
            return .just(.setEditingEmailTextFieldView(true))
        case .inputEmailText(let email):
            let isValidEmail = validateEmail(email)
            return Observable.concat([
                .just(.setEmailText(email)),
                .just(.setIsEnableNextButton(isValidEmail))
            ])
        case .nextButtonTapped:
            return self.userUseCase.checkEmailIsExisted(email: currentState.email)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        UserDefaults.standard.set(self?.currentState.email, forKey: "userEmail")
                        self?.steps.accept(SignupStep.navigateToEnterAuthNumberForSignupViewController)
                    }
                    else {
                        self?.steps.accept(SignupStep.presentToDuplicateEmailAlertController)
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: SignupStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEditingEmailTextFieldView(let isEditing):
            newState.isEditingEmailTextFieldView = isEditing
        case .setEmailText(let email):
            newState.email = email
        case .setIsEnableNextButton(let isEnable):
            newState.isEnableNextButton = isEnable
        }
        return newState
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
