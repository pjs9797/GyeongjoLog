import RxSwift
import Foundation

class EventUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }
    
    // 나의 경조사 목록
    func fetchMyEvents(filterEventType: String? = nil, sortBy: MyEventSortOption = .date) -> Observable<[MyEvent]> {
        return repository.fetchEvents().map { events in
            let filteredEvents = events
                .filter { $0.amount >= 0 }
                .filter { event in
                    guard let filterEventType = filterEventType else { return true }
                    return event.eventType == filterEventType
                }
            
            let groupedEvents = Dictionary(grouping: filteredEvents) { EventKey(eventType: $0.eventType, date: $0.date) }
            let myEvents = groupedEvents.map { (key, value) in
                MyEvent(eventType: key.eventType, date: key.date, eventCnt: value.count, idList: value.map { $0.id })
            }
            
            switch sortBy {
            case .date:
                return myEvents.sorted { $0.date > $1.date }
            case .eventCnt:
                return myEvents.sorted { $0.eventCnt > $1.eventCnt }
            }
        }
    }
    
    // 나의 경조사 요약 목록
    func fetchMyEventSummaries(ids: [String], filterEventType: String? = nil, sortBy: EventSummarySortOption = .date) -> Observable<[EventSummary]> {
        return repository.fetchEvents().map { events in
            let filteredEvents = events
                .filter { ids.contains($0.id) && $0.amount >= 0 }
                .filter { event in
                    guard let filterEventType = filterEventType else { return true }
                    return event.eventType == filterEventType
                }
            
            let eventSummaries = filteredEvents.map { event in
                EventSummary(id: event.id, eventType: event.eventType, name: event.name, phoneNumber: event.phoneNumber, date: event.date, amount: event.amount)
            }
            
            switch sortBy {
            case .date:
                return eventSummaries.sorted { $0.date > $1.date }
            case .amount:
                return eventSummaries.sorted { $0.amount > $1.amount }
            }
        }
    }
    
    // 타인 경조사 요약 목록
    func fetchOtherEventSummaries(filterEventType: String? = nil, sortBy: EventSummarySortOption = .date) -> Observable<[EventSummary]> {
        return repository.fetchEvents().map { events in
            let filteredEvents = events
                .filter { $0.amount < 0 }
                .filter { event in
                    guard let filterEventType = filterEventType else { return true }
                    return event.eventType == filterEventType
                }
            
            let eventSummaries = filteredEvents.map { event in
                EventSummary(id: event.id, eventType: event.eventType, name: event.name, phoneNumber: event.phoneNumber, date: event.date, amount: event.amount)
            }
            
            switch sortBy {
            case .date:
                return eventSummaries.sorted { $0.date > $1.date }
            case .amount:
                return eventSummaries.sorted { $0.amount > $1.amount }
            }
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
    
    func updateEventType(eventType: String, color: String) -> Completable {
        return repository.updateEventType(eventType: eventType, color: color)
    }
}
