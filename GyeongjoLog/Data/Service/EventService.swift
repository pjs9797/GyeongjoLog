import Moya
import Foundation

enum EventService {
    case addEvent(event: Event)
    case updateEvent(eventId: String, event: Event)
    case deleteEvent(eventId: String)
    case fetchMyEvents
    case fetchMyEventsSummary(eventType: String, date: String)
    case fetchOthersEventsSummary
    case fetchSingleEvent(eventId: String)
    case fetchCalendarEvents(date: String)
}

extension EventService: TargetType {
    var baseURL: URL { return URL(string: "http://localhost:8080/events/")! }
    var path: String {
        switch self {
        case .addEvent:
            return "add"
        case .updateEvent(let eventId, _):
            return "update?eventId=\(eventId)"
        case .deleteEvent(let eventId):
            return "delete?eventId=\(eventId)"
        case .fetchMyEvents:
            return "myEvents"
        case .fetchMyEventsSummary(let eventType, let date):
            return "myEvents/summary?eventType=\(eventType)&date=\(date)"
        case .fetchOthersEventsSummary:
            return "othersEvents/summary"
        case .fetchSingleEvent(let eventId):
            return "singleEvent?eventId=\(eventId)"
        case .fetchCalendarEvents(let date):
            return "yearMonth?date=\(date)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addEvent:
            return .post
        case .updateEvent:
            return .put
        case .deleteEvent:
            return .delete
        case .fetchMyEvents, .fetchMyEventsSummary, .fetchOthersEventsSummary, .fetchSingleEvent, .fetchCalendarEvents:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .addEvent(let event):
            let parameters = ["event": event]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateEvent(_, let event):
            let parameters = ["event": event]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteEvent:
            return .requestPlain
        case .fetchMyEvents:
            return .requestPlain
        case .fetchMyEventsSummary:
            return .requestPlain
        case .fetchOthersEventsSummary:
            return .requestPlain
        case .fetchSingleEvent:
            return .requestPlain
        case .fetchCalendarEvents:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)", "Authorization-refresh": "Bearer \(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
