import Moya
import Foundation
import RxMoya
import RxSwift

class StatisticsRepository: StatisticsRepositoryInterface {
    private let provider = MoyaProvider<StatisticsService>()
    
    func fetchIndividualStatistics() -> Observable<[IndividualStatistics]> {
        return provider.rx.request(.fetchIndividualStatistics)
            .filterSuccessfulStatusCodes()
            .map(IndividualStatisticsResponseDTO.self)
            .map{ IndividualStatisticsResponseDTO.toIndividualStatistics(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchMonthlyStatistics() -> RxSwift.Observable<[MonthlyStatistics]> {
        return provider.rx.request(.fetchMonthlyStatistics)
            .filterSuccessfulStatusCodes()
            .map(MonthlyStatisticsReponseDTO.self)
            .map{ MonthlyStatisticsReponseDTO.toMonthlyStatistics(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
