import ReactorKit
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case selectItem(Int)
    }
    
    enum Mutation {
    }
    
    struct State {
        var settings: [String] = ["문의하기","개인정보 처리방침","앱 버전"]
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
            
            return .empty()
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}

