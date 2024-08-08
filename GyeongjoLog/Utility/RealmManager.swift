import RealmSwift
import RxSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()

    func fetchObjects<T: Object>(_ type: T.Type) -> Observable<[T]> {
        let objects = realm.objects(T.self)
        return Observable.just(Array(objects))
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
}
