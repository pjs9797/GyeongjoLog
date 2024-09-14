import RxSwift

protocol EventRepositoryInterface {
    func addEvent(event: Event) -> Observable<String>
    func updateEvent(eventId: String, event: Event) -> Observable<String>
    func deleteEvent(eventId: String) -> Observable<String>
    func fetchMyEvents() -> Observable<[Event]>
    func fetchMyEventsSummary(eventType: String, date: String) -> Observable<[Event]>
    func fetchOthersEventsSummary() -> Observable<[Event]>
    func fetchSingleEvent(eventId: String) -> Observable<Event>
    func fetchCalendarEvents(date: String) -> Observable<[Event]>
}
