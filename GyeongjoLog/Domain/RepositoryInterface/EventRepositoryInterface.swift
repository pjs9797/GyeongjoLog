import RxSwift

protocol EventRepositoryInterface {
    func fetchEvents() -> Observable<[Event]>
    func fetchSingleEvent(id: String) -> Observable<Event?>
    func saveEvent(event: Event) -> Completable
    func deleteEvent(id: String) -> Completable
    func fetchEventTypes() -> Observable<[(String,String)]>
    func updateEventType(eventType: String, color: String) -> Completable
    func updateEvent(event: Event) -> Completable
}
