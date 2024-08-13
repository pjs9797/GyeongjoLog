import ReactorKit
import RxCocoa
import RxFlow

class OthersEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    enum Action {
        // 버튼 탭
        case filterButtonTapped
        case sortButtonTapped
        
        // 검색
        case updateSearchTextField(String)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadOthersEventSummary
    }
    
    enum Mutation {
        case setOthersEventSummary([EventSummary])
        case setFilteredEventSummaries([EventSummary])
    }
    
    struct State {
        var othersEventSummaries: [EventSummary] = []
        var filteredEventSummaries: [EventSummary] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .filterButtonTapped:
            return .empty()
        case .sortButtonTapped:
            return .empty()
            
            // 검색
        case .updateSearchTextField(let text):
            if text.isEmpty {
                return .just(.setFilteredEventSummaries(currentState.othersEventSummaries))
            }
            else {
                let filteredSummaries = currentState.othersEventSummaries.filter { summary in
                    return self.isMatch(summary: summary, query: text)
                }
                return .just(.setFilteredEventSummaries(filteredSummaries))
            }
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadOthersEventSummary:
            return self.eventUseCase.fetchOtherEventSummaries()
                .map{ othersEventSummaries in
                    return .setOthersEventSummary(othersEventSummaries)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setOthersEventSummary(let othersEventSummaries):
            newState.othersEventSummaries = othersEventSummaries
            newState.filteredEventSummaries = othersEventSummaries
        case .setFilteredEventSummaries(let filteredEventSummaries):
            newState.filteredEventSummaries = filteredEventSummaries
        }
        return newState
    }
    
    private func isMatch(summary: EventSummary, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        let formattedPhoneNumber = summary.phoneNumber.replacingOccurrences(of: "-", with: "")
        let lowercasedName = summary.name.lowercased()
        return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
    }
}
