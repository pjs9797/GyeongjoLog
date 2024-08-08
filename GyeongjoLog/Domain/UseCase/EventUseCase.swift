import RxSwift

class EventUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }
    
    // 나의 경조사 목록 (건수)
    func fetchMyEvents() -> Observable<[MyEvent]> {
        return repository.fetchEvents().map { events in
            let groupedEvents = Dictionary(grouping: events) { EventKey(eventType: $0.eventType, date: $0.date) }
            return groupedEvents.map { (key, value) in
                MyEvent(eventType: key.eventType, date: key.date, eventCnt: value.count, idList: value.map { $0.id })
            }
            .sorted { $0.date > $1.date }
        }
    }
    
    // 나의 경조사, 타인 경조사 요약 정보 (금액)
    func fetchEventSummaries(ids: [String]) -> Observable<[EventSummary]> {
        return repository.fetchEvents().map { events in
            events.filter { ids.contains($0.id) }
                .map { event in
                    EventSummary(id: event.id, eventType: event.eventType, name: event.name, date: event.date, amount: event.amount)
                }
                .sorted { $0.date > $1.date }
        }
    }

    // 이벤트
    func fetchEvents() -> Observable<[Event]> {
        return repository.fetchEvents()
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
    func fetchEventTypes() -> Observable<[String]> {
        return repository.fetchEventTypes()
    }
    
    func updateEventType(eventType: String) -> Completable {
        return repository.updateEventType(eventType: eventType)
    }
}
