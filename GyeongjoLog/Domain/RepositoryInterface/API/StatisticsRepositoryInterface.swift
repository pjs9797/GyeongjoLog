import RxSwift

protocol StatisticsRepositoryInterface {
    func fetchIndividualStatistics() -> Observable<[IndividualStatistics]>
    func fetchMonthlyStatistics() -> Observable<[MonthlyStatistics]>
}
