import ReactorKit
import RxCocoa
import RxFlow

class IndividualStatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let statisticsLocalDBUseCase: StatisticsLocalDBUseCase
    
    init(statisticsLocalDBUseCase: StatisticsLocalDBUseCase) {
        self.statisticsLocalDBUseCase = statisticsLocalDBUseCase
    }
    
    enum Action {
        // 검색
        case updateSearchTextField(String)
        
        // 컬렉션뷰 셀 탭
        case selectRelationship(Int)
        case selectIndividualStatistics(Int)
        
        // 개인별 통계 로드
        case loadIndividualStatistics
    }
    
    enum Mutation {
        case setIndividualStatistics([IndividualStatistics])
        case setSearchQuery(String)
        case setSelectRelationship(String)
    }
    
    struct State {
        var relationships: [String] = ["전체","가족", "친구", "직장", "연인", "이웃", "지인"]
        var individualStatistics: [IndividualStatistics] = []
        var searchQuery: String = ""
        var selectedRelationship = "전체"
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 검색
        case .updateSearchTextField(let query):
            return self.statisticsLocalDBUseCase.fetchIndividualStatistics(query: query, filterRelationship: currentState.selectedRelationship)
                .map{ .setIndividualStatistics($0) }
            
            // 컬렉션뷰 셀 탭
        case .selectRelationship(let index):
            let filterRelationship = currentState.relationships[index]
            return self.statisticsLocalDBUseCase.fetchIndividualStatistics(filterRelationship: filterRelationship)
                .flatMap { individualStatistics in
                    Observable.concat([
                        .just(.setSelectRelationship(filterRelationship)),
                        .just(.setIndividualStatistics(individualStatistics))
                    ])
                }
        case .selectIndividualStatistics(let index):
            let individualStatistic = currentState.individualStatistics[index]
            self.steps.accept(StatisticsStep.navigateToDetailIndividualStatisticsViewController(individualStatistics: individualStatistic))
            return .empty()
            
            // 개인별 통계 로드
        case .loadIndividualStatistics:
            return self.statisticsLocalDBUseCase.fetchIndividualStatistics()
                .map{ .setIndividualStatistics($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIndividualStatistics(let individualStatistics):
            newState.individualStatistics = individualStatistics
        case .setSearchQuery(let text):
            newState.searchQuery = text
        case .setSelectRelationship(let relationship):
            newState.selectedRelationship = relationship
        }
        return newState
    }
}

