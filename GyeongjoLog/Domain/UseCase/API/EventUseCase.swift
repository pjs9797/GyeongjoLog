import RxSwift
import Foundation

class EventUseCase {
    private let repository: EventRepositoryInterface
    private let eventTypeRepository: EventTypeRepositoryInterface
    
    init(repository: EventRepositoryInterface, eventTypeRepository: EventTypeRepositoryInterface) {
        self.repository = repository
        self.eventTypeRepository = eventTypeRepository
    }
    
    // 나의 경조사 목록 (필터 및 정렬 포함)
    func fetchMyEvents(filterEventType: String = "필터", sortBy: MyEventSortOption = .date) -> Observable<[MyEvent]> {
        return repository.fetchMyEvents().map { events in
            let filteredEvents = self.filterEventsAboutType(events: events, filterEventType: filterEventType, isPositive: true)
            return self.sortMyEvents(events: filteredEvents, sortBy: sortBy)
        }
    }
    
    // 나의 경조사 요약 목록
    func fetchMyEventSummaries(eventType: String, date: String, query: String? = nil, filterRelationship: String = "필터", sortBy: EventSummarySortOption = .date) -> Observable<[Event]> {
        return repository.fetchMyEventsSummary(eventType: eventType, date: date).map { events in
            let filteredByTypeAndDate = events.filter { event in
                event.eventType == eventType && event.date == date
            }
            let filteredEvents = self.filterEventsAboutRelationship(events: filteredByTypeAndDate, filterRelationship: filterRelationship, isPositive: true)
            let searchedEvents = self.searchEvents(events: filteredEvents, query: query ?? "")
            return self.sortEventSummaries(events: searchedEvents, sortBy: sortBy)
        }
    }

    // 타인 경조사 요약 목록
    func fetchOthersEventSummaries(query: String? = nil, filterRelationship: String = "필터", sortBy: EventSummarySortOption = .date) -> Observable<[Event]> {
        return repository.fetchOthersEventsSummary().map { events in
            let filteredEvents = self.filterEventsAboutRelationship(events: events, filterRelationship: filterRelationship, isPositive: false)
            let searchedEvents = self.searchEvents(events: filteredEvents, query: query ?? "")
            return self.sortEventSummaries(events: searchedEvents, sortBy: sortBy)
        }
    }
    
    // 특정 월의 이벤트 목록 (캘린더용)
    func fetchCalendarEvents(forMonth date: String) -> Observable<[Event]> {
        return repository.fetchCalendarEvents(date: date).map { events in
            return events
        }
    }
    
    // 이벤트 추가
    func addEvent(event: Event) -> Observable<String> {
        return repository.addEvent(event: event)
    }
    
    // 이벤트 삭제
    func deleteEvent(id: String) -> Observable<String> {
        return repository.deleteEvent(eventId: id)
    }
    
    // 이벤트 업데이트
    func updateEvent(event: Event) -> Observable<String> {
        return repository.updateEvent(eventId: event.id, event: event)
    }

    // 이벤트 타입 목록
    func fetchEventTypes() -> Observable<[EventType]> {
        return eventTypeRepository.fetchEventTypes()
            .map { eventTypes in
                eventTypes.map { EventType(name: $0.name, color: $0.color) }
            }
    }
    
    // 이벤트 타입 추가
    func addEventType(eventType: String, color: String) -> Observable<String> {
        return eventTypeRepository.addEventType(eventType: eventType, color: color)
    }
    
    // 필터링 로직 - 이벤트 타입에 따라
    private func filterEventsAboutType(events: [Event], filterEventType: String, isPositive: Bool) -> [Event] {
        return events
            .filter { isPositive ? $0.amount >= 0 : $0.amount < 0 }
            .filter { event in
                if filterEventType == "필터" {
                    return true
                } else {
                    return event.eventType == filterEventType
                }
            }
    }
    
    // 필터링 로직 - 관계에 따라
    private func filterEventsAboutRelationship(events: [Event], filterRelationship: String, isPositive: Bool) -> [Event] {
        return events
            .filter { isPositive ? $0.amount >= 0 : $0.amount < 0 }
            .filter { event in
                if filterRelationship == "필터" {
                    return true
                } else {
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
            return myEvents.sorted {
                if $0.date != $1.date {
                    return $0.date > $1.date
                } else {
                    if $0.eventCnt != $1.eventCnt {
                        return $0.eventCnt > $1.eventCnt
                    } else {
                        return $0.eventType.localizedStandardCompare($1.eventType) == .orderedAscending
                    }
                }
            }
        case .eventCnt:
            return myEvents.sorted {
                if $0.eventCnt != $1.eventCnt {
                    return $0.eventCnt > $1.eventCnt
                } else {
                    if $0.date != $1.date {
                        return $0.date > $1.date
                    } else {
                        return $0.eventType.localizedStandardCompare($1.eventType) == .orderedAscending
                    }
                }
            }
        }
    }
    
    // EventSummary 정렬 로직
    private func sortEventSummaries(events: [Event], sortBy: EventSummarySortOption) -> [Event] {
        switch sortBy {
        case .date:
            return events.sorted {
                if $0.date != $1.date {
                    return $0.date > $1.date
                } else {
                    if abs($0.amount) != abs($1.amount) {
                        return abs($0.amount) > abs($1.amount)
                    } else {
                        return $0.name.localizedStandardCompare($1.name) == .orderedAscending
                    }
                }
            }
        case .amount:
            return events.sorted {
                if abs($0.amount) != abs($1.amount) {
                    return abs($0.amount) > abs($1.amount)
                } else {
                    if $0.date != $1.date {
                        return $0.date > $1.date
                    } else {
                        return $0.name.localizedStandardCompare($1.name) == .orderedAscending
                    }
                }
            }
        }
    }
}
