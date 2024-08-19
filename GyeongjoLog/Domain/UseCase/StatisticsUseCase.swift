import Foundation
import RxSwift

class StatisticsUseCase {
    private let repository: StatisticsRepositoryInterface
    
    init(repository: StatisticsRepositoryInterface) {
        self.repository = repository
    }
    
    // 개인별 통계 데이터 가져오기
    func fetchIndividualStatistics(query: String? = nil, filterRelationship: String = "전체") -> Observable<[IndividualStatistics]> {
        return repository.fetchEvents().map { events in
            // 쿼리가 있을 경우 이벤트를 필터링
            let searchedEvents = query.map { self.searchEvents(events: events, query: $0) } ?? events

            // 이벤트를 이름과 전화번호로 그룹화
            let groupedEvents = self.groupEventsByPerson(events: searchedEvents)

            // 그룹화된 이벤트를 필터링 (관계 필터링)
            let filteredEvents = groupedEvents.filter { (key, events) in
                let relationship = events.first?.relationship ?? "알 수 없음"
                return filterRelationship == "전체" || filterRelationship == relationship
            }

            // 통계 계산
            return filteredEvents.compactMap { (key, events) -> IndividualStatistics? in
                let totalInteractions = events.count
                let totalAmount = events.reduce(0) { $0 + $1.amount }
                let totalReceivedAmount = events.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
                let totalSentAmount = events.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount }

                let eventDetails = events.map { event in
                    return EventDetail(
                        name: event.name,
                        date: event.date,
                        eventType: event.eventType,
                        amount: event.amount
                    )
                }

                return IndividualStatistics(
                    name: key.name,
                    phoneNumber: key.phoneNumber,
                    relationship: events.first?.relationship ?? "알 수 없음",
                    totalInteractions: totalInteractions,
                    totalAmount: totalAmount,
                    totalReceivedAmount: totalReceivedAmount,
                    totalSentAmount: totalSentAmount,
                    eventDetails: eventDetails
                )
            }.sorted { $0.totalInteractions > $1.totalInteractions }
        }
    }

    private func searchEvents(events: [Event], query: String) -> [Event] {
        guard !query.isEmpty else { return events }

        let lowercasedQuery = query.lowercased()
        return events.filter { event in
            let formattedPhoneNumber = event.phoneNumber.replacingOccurrences(of: "-", with: "")
            let lowercasedName = event.name.lowercased()
            return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
        }
    }

    
    // 이번 달에 가장 많이 주고받은 사람의 이름과 통계 정보 가져오기
    func fetchTopIndividualForCurrentMonth() -> Observable<(name: String, statistics: IndividualStatistics)> {
        return repository.fetchEvents().map { events in
            // 이번 달의 이벤트만 필터링
            let calendar = Calendar.current
            let currentDate = Date()
            let currentMonthEvents = events.filter {
                let eventDate = $0.date.toDate()
                return calendar.isDate(eventDate, equalTo: currentDate, toGranularity: .month)
            }
            
            // 이번 달의 이벤트를 이름과 전화번호로 그룹화
            let groupedCurrentMonthEvents = self.groupEventsByPerson(events: currentMonthEvents)
            
            // 이번 달에 상호작용 건수가 가장 많은 사람 찾기
            let topIndividual = groupedCurrentMonthEvents.max {
                $0.value.count < $1.value.count
            }
            
            guard let top = topIndividual else {
                throw NSError(domain: "StatisticsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No individual found for the current month"])
            }
            
            // 전체 이벤트를 이름과 전화번호로 그룹화
            let groupedAllEvents = self.groupEventsByPerson(events: events)
            
            // 상호작용이 가장 많은 사람의 전체 통계 계산
            let statistics = groupedAllEvents.compactMap { (key, events) -> IndividualStatistics? in
                if key.name == top.key.name && key.phoneNumber == top.key.phoneNumber {
                    let totalInteractions = events.count
                    let totalAmount = events.reduce(0) { $0 + $1.amount }
                    let totalReceivedAmount = events.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
                    let totalSentAmount = events.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount }
                    
                    let eventDetails = events.map { event in
                        return EventDetail(
                            name: event.name,
                            date: event.date,
                            eventType: event.eventType,
                            amount: event.amount
                        )
                    }
                    
                    return IndividualStatistics(
                        name: key.name,
                        phoneNumber: key.phoneNumber,
                        relationship: events.first?.relationship ?? "알 수 없음",
                        totalInteractions: totalInteractions,
                        totalAmount: totalAmount,
                        totalReceivedAmount: totalReceivedAmount,
                        totalSentAmount: totalSentAmount,
                        eventDetails: eventDetails
                    )
                }
                return nil
            }.first!
            
            return (name: top.key.name, statistics: statistics)
        }
    }
    
    // 이벤트를 이름과 전화번호로 그룹화
    private func groupEventsByPerson(events: [Event]) -> [PersonKey: [Event]] {
        return Dictionary(grouping: events) { PersonKey(name: $0.name, phoneNumber: $0.phoneNumber) }
    }
    
    // 월별 통계 데이터
    func fetchMonthlyStatistics() -> Observable<[MonthlyStatistics]> {
        return repository.fetchEvents()
            .map { events in
                let currentDate = Date()
                let calendar = Calendar.current
                
                // 마지막 6개월의 달 문자열을 생성
                var lastSixMonths: [String] = []
                for i in 0..<6 {
                    if let date = calendar.date(byAdding: .month, value: -i, to: currentDate) {
                        lastSixMonths.append(date.toMonthYearString())
                    }
                }
                lastSixMonths.reverse()

                // 기본값으로 채운 MonthlyStatistics 객체 생성
                var monthlyStatisticsDict: [String: MonthlyStatistics] = lastSixMonths.reduce(into: [String: MonthlyStatistics]()) { dict, month in
                    dict[month] = MonthlyStatistics(month: month, sentAmount: 0, receivedAmount: 0, transactionCount: 0, eventTypeAmounts: [:])
                }

                // 이벤트를 날짜별로 그룹화
                let groupedByMonth = Dictionary(grouping: events) { event in
                    event.date.toMonthYearString()
                }
                
                // 실제 데이터를 기본값에 병합
                for (month, events) in groupedByMonth {
                    guard var statistics = monthlyStatisticsDict[month] else { continue }
                    statistics.sentAmount = events.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount }
                    statistics.receivedAmount = events.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
                    statistics.transactionCount = events.count
                    
                    var eventTypeAmounts: [String: Int] = [:]
                    for event in events where event.amount < 0 {
                        eventTypeAmounts[event.eventType, default: 0] += event.amount
                    }
                    statistics.eventTypeAmounts = eventTypeAmounts
                    
                    monthlyStatisticsDict[month] = statistics
                }

                // 순서대로 반환
                return lastSixMonths.map { monthlyStatisticsDict[$0]! }
            }
    }
    
    // 평균 보낸 금액을 계산합니다.
    func calculateAverageSentAmount(statistics: [MonthlyStatistics]) -> Int {
        let totalSent = statistics.reduce(0) { $0 + $1.sentAmount }
        return statistics.isEmpty ? 0 : totalSent / statistics.count
    }
    
    // 특정 월의 보낸 금액이 평균보다 얼마나 차이나는지 계산합니다.
    func calculateDifferenceFromAverage(for month: MonthlyStatistics, in statistics: [MonthlyStatistics]) -> Int {
        let averageSentAmount = calculateAverageSentAmount(statistics: statistics)
        return month.sentAmount - averageSentAmount
    }
}
