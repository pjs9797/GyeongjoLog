import Foundation
import RxSwift

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let eventTypeKey = "eventTypes"
    private let onBoardingStartedKey = "onBoardingStarted"
    private let isLoggedInKey = "isLoggedIn"
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
        let userDefaults = UserDefaults.standard
        if userDefaults.array(forKey: eventTypeKey) == nil {
            let eventTypesArray = defaultEventTypes.map { [$0.0, $0.1] }
            userDefaults.set(eventTypesArray, forKey: eventTypeKey)
        }
        if userDefaults.object(forKey: onBoardingStartedKey) == nil {
            userDefaults.set(false, forKey: onBoardingStartedKey)
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
    
    // 온보딩 시작 상태 저장
    func setOnBoardingStarted(_ started: Bool) {
        UserDefaults.standard.set(started, forKey: onBoardingStartedKey)
    }
    
    // 온보딩 시작 상태 가져오기
    func getOnBoardingStarted() -> Bool {
        return UserDefaults.standard.bool(forKey: onBoardingStartedKey)
    }
    
    // 로그인 여부 저장
    func setLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: isLoggedInKey)
    }
    
    // 로그인 여부 확인
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
}
