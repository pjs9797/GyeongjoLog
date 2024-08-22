import ReactorKit
import RxCocoa
import RxFlow

class PhraseReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
//    private let statisticsUseCase: StatisticsUseCase
//    
//    init(statisticsUseCase: StatisticsUseCase) {
//        self.statisticsUseCase = statisticsUseCase
//    }
    
    enum Action {
    }
    
    enum Mutation {
        
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}

