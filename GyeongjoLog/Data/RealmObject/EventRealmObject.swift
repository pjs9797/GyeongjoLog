import RealmSwift
import Foundation

class EventRealmObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var phoneNumber: String
    @Persisted var eventType: String
    @Persisted var date: String
    @Persisted var relationship: String
    @Persisted var amount: Double
    @Persisted var memo: String?

    func toDomain() -> Event {
        return Event(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            eventType: eventType,
            date: date,
            relationship: relationship,
            amount: amount,
            memo: memo
        )
    }

    static func fromDomain(_ event: Event) -> EventRealmObject {
        let object = EventRealmObject()
        object.id = event.id
        object.name = event.name
        object.phoneNumber = event.phoneNumber
        object.eventType = event.eventType
        object.date = event.date
        object.relationship = event.relationship
        object.amount = event.amount
        object.memo = event.memo
        return object
    }
}
