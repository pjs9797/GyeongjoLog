import Moya
import Foundation

enum StatisticsService {
    case fetchIndividualStatistics
    case fetchMonthlyStatistics
    case fetchMostInteractedThisMonth
}

extension StatisticsService: TargetType {
    var baseURL: URL { return URL(string: "http://localhost:8080/statistics/")! }
    var path: String {
        switch self {
        case .fetchIndividualStatistics:
            return "individual"
        case .fetchMonthlyStatistics:
            return "monthly"
        case .fetchMostInteractedThisMonth:
            return "mostInteractedThisMonth"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchIndividualStatistics, .fetchMonthlyStatistics, .fetchMostInteractedThisMonth:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchIndividualStatistics, .fetchMonthlyStatistics, .fetchMostInteractedThisMonth:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "\(accessToken)", "Authorization-refresh": "\(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
