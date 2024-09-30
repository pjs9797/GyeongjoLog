import ReactorKit
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
        if UserDefaultsManager.shared.isLoggedIn() {
            self.initialState = State(settings: ["문의하기","개인정보 처리방침","로그아웃","회원 탈퇴","앱 버전"])
        }
        else {
            self.initialState = State(settings: ["문의하기","개인정보 처리방침","초기 화면으로","앱 버전"])
        }
    }
    
    enum Action {
        case selectItem(Int)
        case logout
        case withdraw
    }
    
    enum Mutation {
    }
    
    struct State {
        var settings: [String]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectItem(let index):
            if index == 0 {
                self.steps.accept(SettingStep.navigateToInquiryViewController)
            }
            else if index == 1 {
                self.steps.accept(SettingStep.navigateToToPViewController)
            }
            else if index == 2 {
                if UserDefaultsManager.shared.isLoggedIn() {
                    self.steps.accept(SettingStep.presentToLogoutAlertController(reactor: self))
                }
                else {
                    self.steps.accept(SettingStep.endFlow)
                }
            }
            else if index == 3 {
                self.steps.accept(SettingStep.presentToWithdrawAlertController(reactor: self))
            }
            
            return .empty()
        case .logout:
            UserDefaultsManager.shared.setLoggedIn(false)
            return self.userUseCase.logout()
                .flatMap { [weak self] resultCode -> Observable<Mutation> in                    
                    self?.steps.accept(SettingStep.endFlow)
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: SettingStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .withdraw:
            UserDefaultsManager.shared.setLoggedIn(false)
            return self.userUseCase.withdraw()
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    self?.steps.accept(SettingStep.endFlow)
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: SettingStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}

