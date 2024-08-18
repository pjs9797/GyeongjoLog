import RxSwift
import RealmSwift

class StatisticsRepository: StatisticsRepositoryInterface {
    private let realmManager = RealmManager.shared
    
    func fetchEvents() -> Observable<[Event]> {
        return realmManager.fetchObjects(EventRealmObject.self)
            .map { $0.map { $0.toDomain() } }
    }
}
