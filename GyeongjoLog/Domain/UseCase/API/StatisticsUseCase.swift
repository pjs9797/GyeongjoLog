import Foundation
import RxSwift

class StatisticsUseCase {
    private let repository: StatisticsRepositoryInterface
    
    init(repository: StatisticsRepositoryInterface) {
        self.repository = repository
    }
    
    // 개인별 통계 데이터 가져오기
    func fetchIndividualStatistics(query: String? = nil, filterRelationship: String = "전체") -> Observable<[IndividualStatistics]> {
        return repository.fetchIndividualStatistics().map { statistics in
            // 쿼리 조건이 있을 경우 해당 조건에 맞는 데이터를 필터링
            let searchedStatistics: [IndividualStatistics]
            if let query = query, !query.isEmpty {
                searchedStatistics = self.searchStatistics(statistics: statistics, query: query)
            } else {
                searchedStatistics = statistics
            }
            
            // 관계 필터링
            let filteredStatistics = self.filterStatisticsByRelationship(statistics: searchedStatistics, relationship: filterRelationship)
            
            // 통계 정렬
            return filteredStatistics.sorted {
                if $0.totalInteractions != $1.totalInteractions {
                    return $0.totalInteractions > $1.totalInteractions
                } else {
                    return $0.name.localizedStandardCompare($1.name) == .orderedAscending
                }
            }
        }
    }
    
    // 이번 달에 상호작용이 가장 많은 사람의 이름과 통계 정보 가져오기
    func fetchTopIndividualForCurrentMonth() -> Observable<(name: String?, statistics: IndividualStatistics?)> {
        return repository.fetchMostInteractedThisMonth()
    }
    
    // 특정 월의 통계와 평균 차이 계산
    func calculateDifferenceFromAverage(for month: MonthlyStatistics, in statistics: [MonthlyStatistics]) -> Int {
        let averageSentAmount = self.calculateAverageSentAmount(statistics: statistics)
        return month.sentAmount - averageSentAmount
    }
    
    // 월별 통계 가져오기
    func fetchMonthlyStatistics() -> Observable<[MonthlyStatistics]> {
        return repository.fetchMonthlyStatistics().map { statistics in
            return statistics.sorted { $0.month < $1.month }
        }
    }
    
    // 개인별 통계에서 쿼리 필터링
    private func searchStatistics(statistics: [IndividualStatistics], query: String) -> [IndividualStatistics] {
        guard !query.isEmpty else { return statistics }

        let lowercasedQuery = query.lowercased()
        return statistics.filter { statistic in
            let formattedPhoneNumber = statistic.phoneNumber.replacingOccurrences(of: "-", with: "")
            let lowercasedName = statistic.name.lowercased()
            return lowercasedName.contains(lowercasedQuery) || formattedPhoneNumber.contains(lowercasedQuery)
        }
    }
    
    // 관계에 따른 통계 필터링
    private func filterStatisticsByRelationship(statistics: [IndividualStatistics], relationship: String) -> [IndividualStatistics] {
        return statistics.filter { relationship == "전체" || $0.relationship == relationship }
    }
    
    // 이번 달 통계만 필터링
    private func filterStatisticsForCurrentMonth(statistics: [IndividualStatistics]) -> [IndividualStatistics] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        // DateFormatter를 사용해 문자열을 Date로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 날짜 형식에 맞춰 변경
        
        return statistics.filter {
            if let firstEvent = $0.eventDetails.first,
               let eventDate = dateFormatter.date(from: firstEvent.date) {
                // 날짜 변환이 성공한 경우에만 필터링
                let eventMonth = Calendar.current.component(.month, from: eventDate)
                return eventMonth == currentMonth
            }
            return false
        }
    }
    
    // 평균 계산
    private func calculateAverageSentAmount(statistics: [MonthlyStatistics]) -> Int {
        let totalSent = statistics.reduce(0) { $0 + $1.sentAmount }
        return statistics.isEmpty ? 0 : totalSent / statistics.count
    }
}
