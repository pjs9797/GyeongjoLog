import ReactorKit
import RxCocoa
import RxFlow

class IndividualStatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let statisticsUseCase: StatisticsUseCase
    
    init(statisticsUseCase: StatisticsUseCase) {
        self.statisticsUseCase = statisticsUseCase
    }
    
    enum Action {
        // 검색
        case updateSearchTextField(String)
        
        // 컬렉션뷰 셀 탭
        case selectRelationship(Int)
        case selectIndividualStatistics(Int)
        case selectTopIndividual
        
        // 개인별 통계 로드
        case loadIndividualStatistics
        case loadTopIndividualStatistics
    }
    
    enum Mutation {
        case setIndividualStatistics([IndividualStatistics])
        case setSearchQuery(String)
        case setSelectRelationship(String)
        case setTopName(String?)
        case setTopIndividualStatistic(IndividualStatistics?)
    }
    
    struct State {
        var relationships: [String] = ["전체","가족", "친구", "직장", "연인", "이웃", "지인"]
        var individualStatistics: [IndividualStatistics] = []
        var searchQuery: String = ""
        var selectedRelationship = "전체"
        var topName: String?
        var topIndividualStatistic: IndividualStatistics?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 검색
        case .updateSearchTextField(let query):
            return self.statisticsUseCase.fetchIndividualStatistics(query: query, filterRelationship: currentState.selectedRelationship)
                .map{ .setIndividualStatistics($0) }
            
            // 컬렉션뷰 셀 탭
        case .selectRelationship(let index):
            let filterRelationship = currentState.relationships[index]
            return self.statisticsUseCase.fetchIndividualStatistics(filterRelationship: filterRelationship)
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
        case .selectTopIndividual:
            if let topIndividualStatistic = currentState.topIndividualStatistic {
                self.steps.accept(StatisticsStep.navigateToDetailIndividualStatisticsViewController(individualStatistics: topIndividualStatistic))
            }
            return .empty()
            
            // 개인별 통계 로드
        case .loadIndividualStatistics:
            return self.statisticsUseCase.fetchIndividualStatistics()
                .map{ .setIndividualStatistics($0) }
        case .loadTopIndividualStatistics:
            return self.statisticsUseCase.fetchTopIndividualForCurrentMonth()
                .flatMap{
                    Observable.concat([
                        .just(.setTopName($0.name)),
                        .just(.setTopIndividualStatistic($0.statistics))
                    ])
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
        case .setTopName(let name):
            newState.topName = name
        case .setTopIndividualStatistic(let individualStatistics):
            newState.topIndividualStatistic = individualStatistics
        }
        return newState
    }
}

