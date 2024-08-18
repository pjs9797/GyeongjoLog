import RxSwift

protocol StatisticsRepositoryInterface {
    func fetchEvents() -> Observable<[Event]>
}
