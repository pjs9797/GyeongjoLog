import Moya
import Foundation

enum EventTypeService {
    case fetchEventTypes
    case addEventType(eventType: String, color: String)
}

extension EventTypeService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.BaseURL)/evenTypes/")! }
    var path: String {
        switch self {
        case .fetchEventTypes:
            return "list"
        case .addEventType:
            return "add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchEventTypes:
            return .get
        case .addEventType:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchEventTypes:
            return .requestPlain
        case .addEventType(let eventType, let color):
            let parameters = ["eventType": eventType, "color": color]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "\(accessToken)", "Authorization-Refresh": "\(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
