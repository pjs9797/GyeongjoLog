import RealmSwift
import Foundation
import RxSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()

    func fetchObjects<T: Object>(_ type: T.Type) -> Observable<[T]> {
        let objects = realm.objects(T.self)
        return Observable.just(Array(objects))
    }
    
    func fetchSingleObject<T: Object>(_ type: T.Type, forPrimaryKey key: String) -> Observable<T?> {
        let object = realm.object(ofType: type, forPrimaryKey: key)
        return Observable.just(object)
    }

    func saveObject<T: Object>(_ object: T) -> Completable {
        return Completable.create { completable in
            do {
                try self.realm.write {
                    self.realm.add(object)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    func deleteObject<T: Object>(_ type: T.Type, forPrimaryKey key: String) -> Completable {
        return Completable.create { completable in
            do {
                if let object = self.realm.object(ofType: type, forPrimaryKey: key) {
                    try self.realm.write {
                        self.realm.delete(object)
                    }
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    func updateObject<T: Object>(_ type: T.Type, forPrimaryKey key: String, with updates: [String: Any]) -> Completable {
        return Completable.create { completable in
            do {
                if let object = self.realm.object(ofType: type, forPrimaryKey: key) {
                    try self.realm.write {
                        for (property, value) in updates {
                            object.setValue(value, forKey: property)
                        }
                    }
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func saveRandomEvents() -> Completable {
        let events = generateRandomEvents()

        return Completable.create { completable in
            let realm = try! Realm()
            do {
                try realm.write {
                    let realmObjects = events.map { event -> EventRealmObject in
                        let realmObject = EventRealmObject()
                        realmObject.id = event.id
                        realmObject.name = event.name
                        realmObject.phoneNumber = event.phoneNumber
                        realmObject.eventType = event.eventType
                        realmObject.date = event.date
                        realmObject.relationship = event.relationship
                        realmObject.amount = event.amount
                        realmObject.memo = event.memo
                        return realmObject
                    }
                    
                    realm.add(realmObjects)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    
    func generateRandomEvents() -> [Event] {
        let eventTypes = ["결혼식", "장례식", "돌잔치", "생일"]
        let relationships = ["가족", "친구", "직장", "연인", "이웃", "지인"]
        
        var events: [Event] = []
        
        for _ in 0..<200 {
            let randomEventType = eventTypes.randomElement() ?? "결혼식"
            let randomRelationship = relationships.randomElement() ?? "친구"
            
            let randomYear = Int.random(in: 2024...2025)
            let randomMonth = Int.random(in: 1...12)
            let randomDay = Int.random(in: 1...28) // 임의로 28일까지 설정
            
            let date = String(format: "%04d.%02d.%02d", randomYear, randomMonth, randomDay)
            
            let randomAmount = -Double.random(in: 50000...100000)
            
            let event = Event(
                id: UUID().uuidString,
                name: "이름 \(UUID().uuidString.prefix(4))", // 임의의 이름
                phoneNumber: "010-\(Int.random(in: 1000...9999))-\(Int.random(in: 1000...9999))",
                eventType: randomEventType,
                date: date,
                relationship: randomRelationship,
                amount: randomAmount,
                memo: nil // 필요한 경우 메모를 추가할 수 있습니다.
            )
            
            events.append(event)
        }
        
        return events
    }
}
