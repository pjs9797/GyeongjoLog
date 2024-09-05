import ReactorKit
import RxCocoa
import RxFlow

class OnBoardingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case startButtonTapped
        case setPage(Int)
        case nextButtonTapped
    }
    
    enum Mutation {
        case setCurrentPage(Int)
        case moveToNextPage
    }
    
    struct State {
        var currentPage: Int = 0
        var isLastPage: Bool {
            return currentPage == 3 // 마지막 페이지는 3번째로 가정
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startButtonTapped:
            UserDefaultsManager.shared.setOnBoardingStarted(true)
            self.steps.accept(AppStep.navigateToBeginingViewController)
            return .empty()
        case .setPage(let page):
            return .just(.setCurrentPage(page))
        case .nextButtonTapped:
            if self.currentState.isLastPage {
                return .just(.setCurrentPage(self.currentState.currentPage))
            } else {
                return .just(.moveToNextPage)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCurrentPage(let page):
            newState.currentPage = page
        case .moveToNextPage:
            newState.currentPage += 1
        }
        return newState
    }
}
