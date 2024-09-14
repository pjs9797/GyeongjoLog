import RxSwift
import RealmSwift

class StatisticsLocalDBRepository: StatisticsLocalDBRepositoryInterface {
    private let realmManager = RealmManager.shared
    
    func fetchEvents() -> Observable<[Event]> {
        return realmManager.fetchObjects(EventRealmObject.self)
            .map { $0.map { $0.toDomain() } }
    }
}
