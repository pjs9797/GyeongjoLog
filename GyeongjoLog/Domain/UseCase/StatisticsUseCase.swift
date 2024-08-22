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
            let filteredEvents = self.filterEventsByRelationship(events: groupedEvents.values.flatMap { $0 }, relationship: filterRelationship)
            
            let groupedFilteredEvents = self.groupEventsByPerson(events: filteredEvents)
            
            // 통계 계산
            return groupedFilteredEvents.compactMap { (key, events) in
                return self.calculateStatistics(for: events, person: key)
            }.sorted {
                if $0.totalInteractions != $1.totalInteractions {
                    return $0.totalInteractions > $1.totalInteractions
                } 
                else {
                    if $0.eventDetails.first?.date != $1.eventDetails.first?.date {
                        return $0.eventDetails.first?.date ?? "" > $1.eventDetails.first?.date ?? ""
                    }
                    else {
                        return $0.name.localizedStandardCompare($1.name) == .orderedAscending
                    }
                }
            }
        }
    }
    
    // 이번 달에 가장 많이 주고받은 사람의 이름과 통계 정보 가져오기
    func fetchTopIndividualForCurrentMonth() -> Observable<(name: String?, statistics: IndividualStatistics?)> {
        return repository.fetchEvents().map { events in
            // 이번 달의 이벤트만 필터링
            let currentMonthEvents = self.filterEventsForCurrentMonth(events: events)
            
            // 이번 달의 이벤트를 이름과 전화번호로 그룹화
            let groupedCurrentMonthEvents = self.groupEventsByPerson(events: currentMonthEvents)
            
            // 이번 달에 상호작용 건수가 가장 많은 사람 찾기
            let topIndividual = groupedCurrentMonthEvents.max {
                if $0.value.count == $1.value.count {
                    // 이벤트 수가 같으면 이름 순서로 비교
                    return $0.key.name.localizedStandardCompare($1.key.name) == .orderedDescending
                } else {
                    // 기본적으로 이벤트 수로 비교
                    return $0.value.count < $1.value.count
                }
            }
            
            // 상호작용이 없으면 nil을 반환
            guard let top = topIndividual else {
                return (name: nil, statistics: nil)
            }
            
            // 전체 이벤트를 이름과 전화번호로 그룹화
            let groupedAllEvents = self.groupEventsByPerson(events: events)
            
            // 상호작용이 가장 많은 사람의 전체 통계 계산
            let statistics = groupedAllEvents.compactMap { (key, events) -> IndividualStatistics? in
                if key.name == top.key.name && key.phoneNumber == top.key.phoneNumber {
                    return self.calculateStatistics(for: events, person: key)
                }
                return nil
            }.first!
            
            return (name: top.key.name, statistics: statistics)
        }
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
                    statistics = self.calculateMonthlyStatistics(events: events, for: month)
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
    
    // 이벤트를 이름과 전화번호로 그룹화
    private func groupEventsByPerson(events: [Event]) -> [PersonKey: [Event]] {
        return Dictionary(grouping: events) { PersonKey(name: $0.name, phoneNumber: $0.phoneNumber) }
    }

    // 쿼리에 따라 이벤트를 필터링
    private func searchEvents(events: [Event], query: String) -> [Event] {
        guard !query.isEmpty else { return events }

        let lowercasedQuery = query.lowercased()
        return events.filter { event in
            let formattedPhoneNumber = event.phoneNumber.replacingOccurrences(of: "-", with: "")
            let lowercasedName = event.name.lowercased()
            return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
        }
    }

    // 이벤트를 기반으로 개인 통계 계산
    private func calculateStatistics(for events: [Event], person: PersonKey) -> IndividualStatistics? {
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
            name: person.name,
            phoneNumber: person.phoneNumber,
            relationship: events.first?.relationship ?? "알 수 없음",
            totalInteractions: totalInteractions,
            totalAmount: totalAmount,
            totalReceivedAmount: totalReceivedAmount,
            totalSentAmount: totalSentAmount,
            eventDetails: eventDetails
        )
    }

    // 관계에 따라 이벤트 필터링
    private func filterEventsByRelationship(events: [Event], relationship: String) -> [Event] {
        return events.filter { event in
            let eventRelationship = event.relationship
            return relationship == "전체" || relationship == eventRelationship
        }
    }

    // 이번 달의 이벤트 필터링
    private func filterEventsForCurrentMonth(events: [Event]) -> [Event] {
        let calendar = Calendar.current
        let currentDate = Date()
        return events.filter {
            let eventDate = $0.date.toDate()
            return calendar.isDate(eventDate, equalTo: currentDate, toGranularity: .month)
        }
    }

    // 월별 통계 계산
    private func calculateMonthlyStatistics(events: [Event], for month: String) -> MonthlyStatistics {
        var sentAmount = 0
        var receivedAmount = 0
        var transactionCount = 0
        var eventTypeAmounts: [String: Int] = [:]
        
        for event in events {
            if event.amount < 0 {
                sentAmount += event.amount
                eventTypeAmounts[event.eventType, default: 0] += event.amount
            } else if event.amount > 0 {
                receivedAmount += event.amount
            }
        }
        transactionCount = events.count
        
        return MonthlyStatistics(
            month: month,
            sentAmount: sentAmount,
            receivedAmount: receivedAmount,
            transactionCount: transactionCount,
            eventTypeAmounts: eventTypeAmounts
        )
    }
}
