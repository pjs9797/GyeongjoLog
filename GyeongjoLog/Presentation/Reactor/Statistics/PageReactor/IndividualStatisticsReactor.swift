import ReactorKit
import RxCocoa
import RxFlow

class IndividualStatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let statisticsUseCase: StatisticsUseCase
    let statisticsLocalDBUseCase: StatisticsLocalDBUseCase
    
    init(statisticsUseCase: StatisticsUseCase, statisticsLocalDBUseCase: StatisticsLocalDBUseCase) {
        self.statisticsUseCase = statisticsUseCase
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
            return self.self.fetchIndividualStatistics(query: query, filterRelationship: currentState.selectedRelationship)
                .map{ .setIndividualStatistics($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: StatisticsStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
            
            // 컬렉션뷰 셀 탭
        case .selectRelationship(let index):
            let filterRelationship = currentState.relationships[index]
            return self.fetchIndividualStatistics(filterRelationship: filterRelationship)
                .flatMap { individualStatistics in
                    Observable.concat([
                        .just(.setSelectRelationship(filterRelationship)),
                        .just(.setIndividualStatistics(individualStatistics))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: StatisticsStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .selectIndividualStatistics(let index):
            let individualStatistic = currentState.individualStatistics[index]
            self.steps.accept(StatisticsStep.navigateToDetailIndividualStatisticsViewController(individualStatistics: individualStatistic))
            return .empty()
            
            // 개인별 통계 로드
        case .loadIndividualStatistics:
            return self.fetchIndividualStatistics()
                .map{ .setIndividualStatistics($0) }
                .catch { [weak self] error in
                    ErrorHandler.handle(error: error) { (step: StatisticsStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
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
    
    private func fetchIndividualStatistics(query: String? = nil, filterRelationship: String = "전체") -> Observable<[IndividualStatistics]> {
        if UserDefaultsManager.shared.isLoggedIn() {
            return self.statisticsUseCase.fetchIndividualStatistics(query: query, filterRelationship: filterRelationship)
        } else {
            return self.statisticsLocalDBUseCase.fetchIndividualStatistics(query: query, filterRelationship: filterRelationship)
        }
    }
}

