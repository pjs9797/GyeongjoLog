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
            let groupedEvents = self.groupEventsByPerson(events: events)
            
            // 쿼리가 nil이거나 비어있다면 전체 데이터 사용
            let filteredEvents: [PersonKey: [Event]]
            if let query = query?.lowercased(), !query.isEmpty {
                filteredEvents = self.filterGroupedEvents(groupedEvents: groupedEvents, query: query, filterRelationship: filterRelationship)
            } else {
                filteredEvents = groupedEvents
            }
            
            return self.calculateStatistics(for: filteredEvents)
        }
    }
    
    // 이번 달에 가장 많이 주고받은 사람의 이름과 통계 정보 가져오기
    func fetchTopIndividualForCurrentMonth() -> Observable<(name: String, statistics: IndividualStatistics)> {
        return repository.fetchEvents().map { events in
            let currentMonthEvents = self.filterEventsForCurrentMonth(events: events)
            let groupedEvents = self.groupEventsByPerson(events: currentMonthEvents)
            let topIndividual = self.findTopIndividualByTotalInteractions(groupedEvents: groupedEvents)
            
            guard let top = topIndividual else {
                throw NSError(domain: "StatisticsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No individual found for the current month"])
            }
            
            let statistics = self.calculateStatistics(for: [top.key: top.value]).first!
            return (name: top.key.name, statistics: statistics)
        }
    }

    // 이벤트를 이름과 전화번호로 그룹화
    private func groupEventsByPerson(events: [Event]) -> [PersonKey: [Event]] {
        return Dictionary(grouping: events) { PersonKey(name: $0.name, phoneNumber: $0.phoneNumber) }
    }

    // 그룹화된 이벤트를 필터링 (쿼리 및 관계 필터링)
    private func filterGroupedEvents(groupedEvents: [PersonKey: [Event]], query: String?, filterRelationship: String) -> [PersonKey: [Event]] {
        return groupedEvents.filter { (key, events) in
            if let query = query?.lowercased(),
               !key.name.lowercased().contains(query) && !key.phoneNumber.contains(query) {
                return false
            }
            
            let relationship = events.first?.relationship ?? "알 수 없음"
            return filterRelationship == "전체" || filterRelationship == relationship
        }
    }

    // 통계 계산
    private func calculateStatistics(for groupedEvents: [PersonKey: [Event]]) -> [IndividualStatistics] {
        return groupedEvents.compactMap { (key, events) -> IndividualStatistics? in
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
    
    // 이번 달의 이벤트만 필터링
    private func filterEventsForCurrentMonth(events: [Event]) -> [Event] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        return events.filter {
            let eventDate = $0.date.toDate()
            return calendar.isDate(eventDate, equalTo: currentDate, toGranularity: .month)
        }
    }
    
    // 이번 달에 상호작용 건수가 가장 많은 사람 찾기
    private func findTopIndividualByTotalInteractions(groupedEvents: [PersonKey: [Event]]) -> (key: PersonKey, value: [Event])? {
        return groupedEvents.max {
            $0.value.count < $1.value.count
        }
    }
}
