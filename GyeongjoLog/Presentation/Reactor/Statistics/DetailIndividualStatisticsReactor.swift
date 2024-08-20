import ReactorKit
import RxCocoa
import RxFlow

class DetailIndividualStatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let statisticsUseCase: StatisticsUseCase
    
    init(statisticsUseCase: StatisticsUseCase, individualStatistics:IndividualStatistics) {
        self.statisticsUseCase = statisticsUseCase
        
        let totalInteractions = "주고받은 횟수 \(individualStatistics.totalInteractions)회"
        
        let absTotalAmount = abs(individualStatistics.totalAmount)
        var totalAmount: String
        if individualStatistics.totalAmount >= 0 {
            totalAmount = "총 금액 +\(absTotalAmount.formattedWithComma())원"
        }
        else {
            totalAmount = "총 금액 -\(absTotalAmount.formattedWithComma())원"
        }
        
        let totalReceivedAmount = "+\(individualStatistics.totalReceivedAmount.formattedWithComma())"
        let totalSentAmount = "\(individualStatistics.totalSentAmount.formattedWithComma())"
        
        self.initialState = State(name: individualStatistics.name, phoneNumber: individualStatistics.phoneNumber, relationship: individualStatistics.relationship, totalInteractions: totalInteractions, totalAmount: totalAmount, totalReceivedAmount: totalReceivedAmount, totalSentAmount: totalSentAmount, eventDetails: individualStatistics.eventDetails.sorted{ $0.date > $1.date })
    }
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var name: String
        var phoneNumber: String
        var relationship: String
        var totalInteractions: String
        var totalAmount: String
        var totalReceivedAmount: String
        var totalSentAmount: String
        var eventDetails: [EventDetail]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(StatisticsStep.popViewController)
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

