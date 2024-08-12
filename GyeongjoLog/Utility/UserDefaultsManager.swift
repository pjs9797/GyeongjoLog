import Foundation
import RxSwift

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let eventTypeKey = "eventTypes"
    private let defaultEventTypes: [(String, String)] = [
        ("결혼식", "PinkCustom"),
        ("장례식", "BlackCustom"),
        ("생일", "OrangeCustom"),
        ("돌잔치", "Blue-Selection")
    ]
    
    private init() {
        initializeDefaultEventTypes()
    }
    
    private func initializeDefaultEventTypes() {
        let defaults = UserDefaults.standard
        if defaults.array(forKey: eventTypeKey) == nil {
            let eventTypesArray = defaultEventTypes.map { [$0.0, $0.1] }
            defaults.set(eventTypesArray, forKey: eventTypeKey)
        }
    }
    
    func fetchEventTypes() -> Observable<[(String, String)]> {
        let defaults = UserDefaults.standard
        let savedEventTypesArray = defaults.array(forKey: eventTypeKey) as? [[String]] ?? defaultEventTypes.map { [$0.0, $0.1] }
        let savedEventTypes = savedEventTypesArray.map { ($0[0], $0[1]) }
        return Observable.just(savedEventTypes)
    }
    
    func updateEventType(eventType: String, color: String) -> Completable {
        return Completable.create { completable in
            var savedEventTypesArray = UserDefaults.standard.array(forKey: self.eventTypeKey) as? [[String]] ?? []
            if let index = savedEventTypesArray.firstIndex(where: { $0[0] == eventType }) {
                savedEventTypesArray[index][1] = color
            } else {
                savedEventTypesArray.append([eventType, color])
            }
            UserDefaults.standard.set(savedEventTypesArray, forKey: self.eventTypeKey)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func fetchColor(forEventType eventType: String) -> String? {
        let eventTypes = fetchEventTypesSync()
        return eventTypes.first(where: { $0.0 == eventType })?.1
    }
    
    private func fetchEventTypesSync() -> [(String, String)] {
        let defaults = UserDefaults.standard
        let savedEventTypesArray = defaults.array(forKey: eventTypeKey) as? [[String]] ?? defaultEventTypes.map { [$0.0, $0.1] }
        return savedEventTypesArray.map { ($0[0], $0[1]) }
    }
}
