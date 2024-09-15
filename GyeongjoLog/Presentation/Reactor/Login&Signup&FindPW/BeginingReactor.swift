import ReactorKit
import RxCocoa
import RxFlow

class BeginingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case loginButtonTapped
        case signupButtonTapped
        case startNotLoginButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginButtonTapped:
            self.steps.accept(AppStep.navigateToLoginViewController)
            return .empty()
            
        case .signupButtonTapped:
            self.steps.accept(AppStep.goToSignupFlow)
            return .empty()
            
        case .startNotLoginButtonTapped:
            UserDefaultsManager.shared.setLoggedIn(false)
            self.steps.accept(AppStep.navigateToTabBarController)
            return .empty()
        }
    }
}
