import RxSwift

class EventRepository: EventRepositoryInterface {
    private let realmManager = RealmManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared

    func fetchEvents() -> Observable<[Event]> {
        return realmManager.fetchObjects(EventRealmObject.self)
            .map { $0.map { $0.toDomain() } }
    }

    func saveEvent(event: Event) -> Completable {
        let realmObject = EventRealmObject.fromDomain(event)
        return realmManager.saveObject(realmObject)
    }

    func deleteEvent(id: String) -> Completable {
        return realmManager.deleteObject(EventRealmObject.self, forPrimaryKey: id)
    }
    
    func updateEvent(event: Event) -> Completable {
        let updates: [String: Any] = [
            "name": event.name,
            "phoneNumber": event.phoneNumber,
            "eventType": event.eventType,
            "date": event.date,
            "relationship": event.relationship,
            "amount": event.amount,
            "memo": event.memo as Any
        ]
        return realmManager.updateObject(EventRealmObject.self, forPrimaryKey: event.id, with: updates)
    }

    func fetchEventTypes() -> Observable<[(String,String)]> {
        return userDefaultsManager.fetchEventTypes()
    }

    func updateEventType(eventType: String, color: String) -> Completable {
        return userDefaultsManager.updateEventType(eventType: eventType, color: color)
    }
}
