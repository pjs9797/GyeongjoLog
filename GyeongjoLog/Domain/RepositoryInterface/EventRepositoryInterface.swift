import RxSwift

protocol EventRepositoryInterface {
    func fetchEvents() -> Observable<[Event]>
    func saveEvent(event: Event) -> Completable
    func deleteEvent(id: String) -> Completable
    func fetchEventTypes() -> Observable<[String]>
    func updateEventType(eventType: String) -> Completable
    func updateEvent(event: Event) -> Completable
}
