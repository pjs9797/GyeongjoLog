import ReactorKit
import RxCocoa
import RxFlow

class StatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        // 페이징 처리
        case selectItem(Int)
        case setPreviousIndex(Int)
    }
    
    enum Mutation {
        case setSelectedItem(Int)
        case setPreviousIndex(Int)
    }
    
    struct State {
        var selectedItem: Int = 0
        var previousIndex: Int = 0
        var categories: [String] = ["개인별","월별"]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 페이징 처리
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .setPreviousIndex(let index):
            return .just(.setPreviousIndex(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedItem(let index):
            newState.selectedItem = index
        case .setPreviousIndex(let index):
            newState.previousIndex = index
        }
        return newState
    }
}
