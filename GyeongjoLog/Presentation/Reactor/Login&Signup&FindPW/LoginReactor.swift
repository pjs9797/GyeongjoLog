import ReactorKit
import RxCocoa
import RxFlow

class LoginReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        
        case emailTextFieldTapped
        case inputEmailText(String)
        
        case passwordTextFieldTapped
        case inputPasswordText(String)
        case showPasswordButtonTapped
        
        case loginButtonTapped
        case findPasswordButtonTapped
    }
    
    enum Mutation {
        case setEditingEmailTextFieldView(Bool)
        case setEmailText(String)
        
        case setEditingPasswordTextFieldView(Bool)
        case setPasswordText(String)
        case setSecurePassword
    }
    
    struct State {
        var isEditingEmailTextFieldView: Bool = false
        var isEditingPasswordTextFieldView: Bool = false
        
        var email: String = ""
        var password: String = ""
        var isSecurePassword: Bool = true
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AppStep.popViewController)
            return .empty()
            
        case .emailTextFieldTapped:
            return .concat([
                .just(.setEditingEmailTextFieldView(true)),
                .just(.setEditingPasswordTextFieldView(false)),
            ])
        case .inputEmailText(let email):
            return .just(.setEmailText(email))
            
        case .passwordTextFieldTapped:
            return .concat([
                .just(.setEditingEmailTextFieldView(false)),
                .just(.setEditingPasswordTextFieldView(true)),
            ])
        case .inputPasswordText(let password):
            return .just(.setPasswordText(password))
        case .showPasswordButtonTapped:
            return .just(.setSecurePassword)
            
        case .loginButtonTapped:
            return .empty()
        case .findPasswordButtonTapped:
            self.steps.accept(AppStep.navigateToEnterEmailForFindPWViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEditingEmailTextFieldView(let isEditing):
            newState.isEditingEmailTextFieldView = isEditing
        case .setEmailText(let email):
            newState.email = email
            
        case .setEditingPasswordTextFieldView(let isEditing):
            newState.isEditingPasswordTextFieldView = isEditing
        case .setPasswordText(let password):
            newState.password = password
        case .setSecurePassword:
            newState.isSecurePassword = !newState.isSecurePassword
        }
        return newState
    }
}
