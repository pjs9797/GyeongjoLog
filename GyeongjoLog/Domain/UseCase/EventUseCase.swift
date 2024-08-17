import RxSwift
import Foundation

class EventUseCase {
    private let repository: EventRepository
    
    init(repository: EventRepository) {
        self.repository = repository
    }
    
    // 나의 경조사 목록
    func fetchMyEvents(filterEventType: String = "필터", sortBy: MyEventSortOption = .date) -> Observable<[MyEvent]> {
        return repository.fetchEvents().map { events in
            let filteredEvents = self.filterEventsAboutType(events: events, filterEventType: filterEventType, isPositive: true)
            return self.sortMyEvents(events: filteredEvents, sortBy: sortBy)
        }
    }
    
    // 나의 경조사 요약 목록
    func fetchMyEventSummaries(eventType: String, date: String, query: String? = nil, filterRelationship: String = "필터", sortBy: EventSummarySortOption = .date) -> Observable<[Event]> {
        return repository.fetchEvents().map { events in
            let filteredByTypeAndDate = events.filter { event in
                event.eventType == eventType && event.date == date
            }
            let filteredEvents = self.filterEventsAboutRelationship(events: filteredByTypeAndDate, filterRelationship: filterRelationship, isPositive: true)
            let searchedEvents = self.searchEvents(events: filteredEvents, query: query ?? "")
            return self.sortEventSummaries(events: searchedEvents, sortBy: sortBy)
        }
    }

    
    // 타인 경조사 요약 목록
    func searchAndFilterOtherEventSummaries(query: String? = nil, filterRelationship: String = "필터", sortBy: EventSummarySortOption = .date) -> Observable<[Event]> {
        return repository.fetchEvents().map { events in
            let filteredEvents = self.filterEventsAboutRelationship(events: events, filterRelationship: filterRelationship, isPositive: false)
            let searchedEvents = self.searchEvents(events: filteredEvents, query: query ?? "")
            return self.sortEventSummaries(events: searchedEvents, sortBy: sortBy)
        }
    }
    
    // 특정 월의 이벤트를 가져옴
    func fetchEvents(forMonth date: Date) -> Observable<[Event]> {
        return repository.fetchEvents()
            .map { events in
                let calendar = Calendar.current
                return events.filter {
                    let eventDate = $0.date.toDate()
                    return calendar.isDate(eventDate, equalTo: date, toGranularity: .month)
                }
            }
    }
    
    // 이벤트
    func fetchSingleEvent(id: String) -> Observable<Event?> {
        return repository.fetchSingleEvent(id: id)
    }
    
    func saveEvent(event: Event) -> Completable {
        return repository.saveEvent(event: event)
    }
    
    func deleteEvent(id: String) -> Completable {
        return repository.deleteEvent(id: id)
    }
    
    func updateEvent(event: Event) -> Completable {
        return repository.updateEvent(event: event)
    }
    
    // 이벤트 타입
    func fetchEventTypes() -> Observable<[EventType]> {
        return repository.fetchEventTypes()
            .map { eventTypesDict in
                eventTypesDict.map { EventType(name: $0.0, color: $0.1) }
            }
    }
    
    // 이벤트 타입 추가
    func updateEventType(eventType: String, color: String) -> Completable {
        return repository.updateEventType(eventType: eventType, color: color)
    }
    
    // 이벤트 필터링 로직 - 타입
    private func filterEventsAboutType(events: [Event], filterEventType: String, isPositive: Bool) -> [Event] {
        return events
            .filter { isPositive ? $0.amount >= 0 : $0.amount < 0 }
            .filter { event in
                if filterEventType == "필터" {
                    return true
                }
                else {
                    return event.eventType == filterEventType
                }
            }
    }
    
    // 이벤트 필터링 로직 - 관계
    private func filterEventsAboutRelationship(events: [Event], filterRelationship: String, isPositive: Bool) -> [Event] {
        return events
            .filter { isPositive ? $0.amount >= 0 : $0.amount < 0 }
            .filter { event in
                if filterRelationship == "필터" {
                    return true
                }
                else {
                    return event.relationship == filterRelationship
                }
            }
    }
    
    // 이벤트 검색 로직
    private func searchEvents(events: [Event], query: String) -> [Event] {
        guard !query.isEmpty else { return events }
        
        let lowercasedQuery = query.lowercased()
        return events.filter { event in
            let formattedPhoneNumber = event.phoneNumber.replacingOccurrences(of: "-", with: "")
            let lowercasedName = event.name.lowercased()
            return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
        }
    }
    
    // MyEvent 정렬 로직
    private func sortMyEvents(events: [Event], sortBy: MyEventSortOption) -> [MyEvent] {
        let groupedEvents = Dictionary(grouping: events) { EventKey(eventType: $0.eventType, date: $0.date) }
        let myEvents = groupedEvents.map { (key, value) in
            MyEvent(eventType: key.eventType, date: key.date, eventCnt: value.count)
        }
        switch sortBy {
        case .date:
            return myEvents.sorted { $0.date > $1.date }
        case .eventCnt:
            return myEvents.sorted { $0.eventCnt > $1.eventCnt }
        }
    }
    
    // EventSummary 정렬 로직
    private func sortEventSummaries(events: [Event], sortBy: EventSummarySortOption) -> [Event] {
        switch sortBy {
        case .date:
            return events.sorted { $0.date > $1.date }
        case .amount:
            return events.sorted { $0.amount > $1.amount }
        }
    }
}
