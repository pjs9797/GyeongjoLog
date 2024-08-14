import ReactorKit
import RxCocoa
import RxFlow

class MyEventSummaryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    
    init(eventUseCase: EventUseCase, eventType: String, idList:[String]) {
        self.eventUseCase = eventUseCase
        self.initialState = State(eventType: eventType, idList: idList)
    }
    
    enum Action {
        // 네비게이션 버튼 탭
        case backButtonTapped
        case calendarButtonTapped
        case plusButtonTapped
        
        // 버튼 탭
        case filterButtonTapped
        case sortButtonTapped
        
        // 검색
        case updateSearchTextField(String)
        
        // 나의 경조사 컬렉션뷰 셀 데이터 로드
        case loadMyEventSummary
    }
    
    enum Mutation {
        case setMyEventSummary([EventSummary])
        case setFilteredMyEventSummary([EventSummary])
    }
    
    struct State {
        var eventType: String
        var idList: [String]
        var myEventSummaries: [EventSummary] = []
        var filteredMyEventSummaries: [EventSummary] = []
        var amount: Int = 0
        var eventCnt: String = ""
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 네비게이션 버튼 탭
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
        case .calendarButtonTapped:
            self.steps.accept(EventHistoryStep.navigateToCalendarViewController)
            return .empty()
        case .plusButtonTapped:
            self.steps.accept(EventHistoryStep.navigateToAddEventViewController)
            return .empty()
            
            // 버튼 탭
        case .filterButtonTapped:
            return .empty()
        case .sortButtonTapped:
            return .empty()
            
            // 검색
        case .updateSearchTextField(let text):
            if text.isEmpty {
                return .just(.setFilteredMyEventSummary(currentState.myEventSummaries))
            }
            else {
                let filteredSummaries = currentState.myEventSummaries.filter { summary in
                    return self.isMatch(summary: summary, query: text)
                }
                return .just(.setFilteredMyEventSummary(filteredSummaries))
            }
            
            // 나의 경조사 컬렉션뷰 셀 데이터 처리
        case .loadMyEventSummary:
            return self.eventUseCase.fetchMyEventSummaries(idList: currentState.idList)
                .map{ myEventSummaries in
                    return .setMyEventSummary(myEventSummaries)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMyEventSummary(let myEventSummaries):
            newState.myEventSummaries = myEventSummaries
            newState.filteredMyEventSummaries = myEventSummaries
            newState.amount = sumAllAmount(myEventSummaries: myEventSummaries)
            newState.eventCnt = "\(myEventSummaries.count)명의 내역입니다"
        case .setFilteredMyEventSummary(let filteredMyEventSummaries):
            newState.filteredMyEventSummaries = filteredMyEventSummaries
        }
        return newState
    }
    
    private func sumAllAmount(myEventSummaries: [EventSummary]) -> Int {
        var amount = 0
        for myEventSummary in myEventSummaries {
            amount += myEventSummary.amount
        }
        return amount
    }
    
    private func isMatch(summary: EventSummary, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        let formattedPhoneNumber = summary.phoneNumber.replacingOccurrences(of: "-", with: "")
        let lowercasedName = summary.name.lowercased()
        return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
    }
}
