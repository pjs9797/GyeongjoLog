import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class EnterPasswordForSignupReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
    }
    
    enum Action {
        case backButtonTapped
        
        case passwordTextFieldTapped
        case inputPasswordText(String)
        case showPasswordButtonTapped
        
        case rePasswordTextFieldTapped
        case inputRePasswordText(String)
        case showRePasswordButtonTapped
        
        case nextButtonTapped
    }
    
    enum Mutation {
        case setEditingPasswordTextFieldView(Bool)
        case setPasswordText(String)
        case setSecurePassword
        case setVaildPassword(Bool)
        
        case setEditingRePasswordTextFieldView(Bool)
        case setRePasswordText(String)
        case setSecureRePassword
        case setVaildRePassword(Bool)
        
        case setIsEnableNextButton
    }
    
    struct State {
        var isEditingPasswordTextFieldView: Bool = false
        var isEditingRePasswordTextFieldView: Bool = false
        
        var password: String = ""
        var rePassword: String = ""
        
        var isSecurePassword: Bool = true
        var isSecureRePassword: Bool = true
        
        var isValidPassword: Bool = false
        var isValidRePassword: Bool = false
        
        var isEnableNextButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.popViewController)
            return .empty()
            
        case .passwordTextFieldTapped:
            return .concat([
                .just(.setEditingPasswordTextFieldView(true)),
                .just(.setEditingRePasswordTextFieldView(false)),
            ])
        case .inputPasswordText(let password):
            return .concat([
                .just(.setPasswordText(password)),
                .just(.setVaildPassword(validatePassword(password))),
                .just(.setIsEnableNextButton)
            ])
        case .showPasswordButtonTapped:
            return .just(.setSecurePassword)
            
        case .rePasswordTextFieldTapped:
            return .concat([
                .just(.setEditingPasswordTextFieldView(false)),
                .just(.setEditingRePasswordTextFieldView(true)),
            ])
        case .inputRePasswordText(let rePassword):
            return .concat([
                .just(.setRePasswordText(rePassword)),
                .just(.setVaildRePassword(validatePassword(rePassword) && currentState.password == rePassword)),
                .just(.setIsEnableNextButton)
            ])
        case .showRePasswordButtonTapped:
            return .just(.setSecureRePassword)
            
        case .nextButtonTapped:
            return self.userUseCase.join(email: UserDefaults.standard.string(forKey: "userEmail") ?? "", password: currentState.rePassword)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self?.steps.accept(SignupStep.completeSignupFlow)
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
        case .setEditingPasswordTextFieldView(let isEditing):
            newState.isEditingPasswordTextFieldView = isEditing
        case .setPasswordText(let password):
            newState.password = password
        case .setSecurePassword:
            newState.isSecurePassword = !newState.isSecurePassword
            
        case .setEditingRePasswordTextFieldView(let isEditing):
            newState.isEditingRePasswordTextFieldView = isEditing
        case .setRePasswordText(let rePassword):
            newState.rePassword = rePassword
        case .setSecureRePassword:
            newState.isSecureRePassword = !newState.isSecureRePassword
            
        case .setVaildPassword(let isVaild):
            newState.isValidPassword = isVaild
        case .setVaildRePassword(let isVaild):
            newState.isValidRePassword = isVaild
            
        case .setIsEnableNextButton:
            newState.isEnableNextButton = newState.isValidPassword && newState.isValidRePassword
        }
        return newState
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard password.count >= 10 else { return false }

        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{10,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: password)
    }
}
