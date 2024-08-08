import Foundation
import RxSwift

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let eventTypeKey = "eventTypes"
    private let defaultEventTypes = ["결혼식", "장례식", "생일", "돌잔치"]
    
    private init() {
        initializeDefaultEventTypes()
    }
    
    private func initializeDefaultEventTypes() {
        let defaults = UserDefaults.standard
        if defaults.array(forKey: eventTypeKey) == nil {
            defaults.set(defaultEventTypes, forKey: eventTypeKey)
        }
    }
    
    func fetchEventTypes() -> Observable<[String]> {
        let defaults = UserDefaults.standard
        let savedEventTypes = defaults.array(forKey: eventTypeKey) as? [String] ?? defaultEventTypes
        return Observable.just(savedEventTypes)
    }
    
    func updateEventType(eventType: String) -> Completable {
        return Completable.create { completable in
            var savedEventTypes = UserDefaults.standard.array(forKey: self.eventTypeKey) as? [String] ?? []
            if !savedEventTypes.contains(eventType) {
                savedEventTypes.append(eventType)
                UserDefaults.standard.set(savedEventTypes, forKey: self.eventTypeKey)
            }
            completable(.completed)
            return Disposables.create()
        }
    }
}
