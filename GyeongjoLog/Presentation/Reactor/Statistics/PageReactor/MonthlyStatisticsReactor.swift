import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class MonthlyStatisticsReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let statisticsUseCase: StatisticsLocalDBUseCase
    
    init(statisticsUseCase: StatisticsLocalDBUseCase) {
        self.statisticsUseCase = statisticsUseCase
    }
    
    enum Action {
        case selectMonth(Int)
        case loadMonthlyStatistics
        case loadTopIndividualStatistics
        case selectTopIndividual
    }
    
    enum Mutation {
        case setTopName(String?)
        case setTopIndividualStatistic(IndividualStatistics?)
        
        case setMonthlyStatistics([MonthlyStatistics])
        case setIsEmptyMonthlyStatistics(Bool)
        case setSelectedMonth(MonthlyStatistics)
        case setDifferenceAmountFromAverage(Int)
        case setReceivedAmount(String)
        case setSentAmount(String)
        case setTopEventType(String,String)
        case setSentPieText(String)
        case setPieChartDetails([PieChartDetail])
    }
    
    struct State {
        var topName: String?
        var topIndividualStatistic: IndividualStatistics?
        
        var monthlyStatistics: [MonthlyStatistics] = []
        var isEmptyMonthlyStatistics: Bool = true
        var selectedMonthlyStatistics: MonthlyStatistics?
        var differenceAmountFromAverage: Int = 0
        var receivedAmount: String = ""
        var sentAmount: String = ""
        var topEventType: (String,String) = ("","")
        var sentPieText: String = ""
        var pieChartDetails: [PieChartDetail] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadTopIndividualStatistics:
            return self.statisticsUseCase.fetchTopIndividualForCurrentMonth()
                .flatMap{
                    Observable.concat([
                        .just(.setTopName($0.name)),
                        .just(.setTopIndividualStatistic($0.statistics))
                    ])
                }
        case .selectTopIndividual:
            if let topIndividualStatistic = currentState.topIndividualStatistic {
                self.steps.accept(StatisticsStep.navigateToDetailIndividualStatisticsViewController(individualStatistics: topIndividualStatistic))
            }
            return .empty()
            
        case .selectMonth(let index):
            let selectedMonthlyStatistics = currentState.monthlyStatistics[index]
            let differenceFromAverage = self.statisticsUseCase.calculateDifferenceFromAverage(for: selectedMonthlyStatistics, in: currentState.monthlyStatistics)
            var receivedAmount = "+\(currentState.monthlyStatistics[index].receivedAmount.formattedWithComma())원"
            if currentState.monthlyStatistics[index].receivedAmount == 0 {
                receivedAmount = "\(currentState.monthlyStatistics[index].receivedAmount.formattedWithComma())원"
            }
            let sentAmount = "\(currentState.monthlyStatistics[index].sentAmount.formattedWithComma())원"
            
            var topEventType: String = ""
            let components = selectedMonthlyStatistics.month.split(separator: ".")
            let selectedMonth = components.count == 2 ? "\(components[1])월" : ""
            if let eventType = currentState.monthlyStatistics[index].eventTypeAmounts.max(by: { $0.value > $1.value })?.key {
                topEventType = eventType
            }
            let absSentAmount = abs(currentState.monthlyStatistics[index].sentAmount).formattedWithComma()
            let secondPieText = "이번달 총 \(absSentAmount)원을 썼어요"
            
            let pieChartDetails = selectedMonthlyStatistics.eventTypeAmounts.map { eventType, amount in
                let totalAmount = selectedMonthlyStatistics.eventTypeAmounts.values.reduce(0, +)
                let percentage = totalAmount == 0 ? 0.0 : (Double(amount) / Double(totalAmount)) * 100.0
                return PieChartDetail(eventType: eventType, percentage: round(percentage * 10) / 10.0, amount: amount)
            }.sorted {
                if $0.percentage != $1.percentage {
                    return $0.percentage > $1.percentage
                }
                else {
                    return $0.eventType.localizedStandardCompare($1.eventType) == .orderedAscending
                }
            }
            
            return .concat([
                .just(.setDifferenceAmountFromAverage(differenceFromAverage)),
                .just(.setReceivedAmount(receivedAmount)),
                .just(.setSentAmount(sentAmount)),
                .just(.setTopEventType(selectedMonth, topEventType)),
                .just(.setSentPieText(secondPieText)),
                .just(.setPieChartDetails(pieChartDetails)),
                .just(.setSelectedMonth(selectedMonthlyStatistics))
            ])
            
        case .loadMonthlyStatistics:
            return self.statisticsUseCase.fetchMonthlyStatistics()
                .flatMap { monthlyStatistics -> Observable<Mutation> in
                    let isEmpty = monthlyStatistics.allSatisfy { $0.receivedAmount == 0 }
                    return Observable.concat([
                        .just(.setMonthlyStatistics(monthlyStatistics)),
                        .just(.setIsEmptyMonthlyStatistics(isEmpty))
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTopName(let name):
            newState.topName = name
        case .setTopIndividualStatistic(let individualStatistics):
            newState.topIndividualStatistic = individualStatistics
            
        case .setMonthlyStatistics(let monthlyStatistics):
            newState.monthlyStatistics = monthlyStatistics
        case .setIsEmptyMonthlyStatistics(let isEmpty):
                newState.isEmptyMonthlyStatistics = isEmpty
        case .setSelectedMonth(let selectedMonthlyStatistics):
            newState.selectedMonthlyStatistics = selectedMonthlyStatistics
        case .setDifferenceAmountFromAverage(let differenceAmountFromAverage):
            newState.differenceAmountFromAverage = differenceAmountFromAverage
        case .setReceivedAmount(let receivedAmount):
            newState.receivedAmount = receivedAmount
        case .setSentAmount(let sentAmount):
            newState.sentAmount = sentAmount
        case .setTopEventType(let month, let eventType):
            newState.topEventType = (month, eventType)
        case .setSentPieText(let text):
            newState.sentPieText = text
        case .setPieChartDetails(let details):
            newState.pieChartDetails = details
        }
        return newState
    }
}
