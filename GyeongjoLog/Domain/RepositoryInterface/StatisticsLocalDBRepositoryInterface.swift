import RxSwift

protocol StatisticsLocalDBRepositoryInterface {
    func fetchEvents() -> Observable<[Event]>
}
