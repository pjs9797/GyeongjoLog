import RxSwift

protocol EventTypeRepositoryInterface {
    func fetchEventTypes() -> Observable<[EventType]>
    func addEventType(eventType: String, color: String) -> Observable<String>
}
