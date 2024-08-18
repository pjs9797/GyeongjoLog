import ReactorKit
import RxCocoa
import RxFlow

class OnBoardingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case startButtonTapped
        case setPage(Int)
    }

    enum Mutation {
        case setCurrentPage(Int)
    }

    struct State {
        var currentPage: Int = 0
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startButtonTapped:
            UserDefaultsManager.shared.setOnBoardingStarted(true)
            self.steps.accept(AppStep.navigateToTabBarController)
            return .empty()
        case .setPage(let page):
            return .just(.setCurrentPage(page))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCurrentPage(let page):
            newState.currentPage = page
        }
        return newState
    }
}
