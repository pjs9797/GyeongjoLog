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
        case .updateEvent:
            return "update"
        case .deleteEvent:
            return "delete"
        case .fetchMyEvents:
            return "myEvents"
        case .fetchMyEventsSummary:
            return "myEvents/summary"
        case .fetchOthersEventsSummary:
            return "othersEvents/summary"
        case .fetchSingleEvent:
            return "singleEvent"
        case .fetchCalendarEvents:
            return "yearMonth"
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
            let parameters: [String: Any] = [
                    "name": event.name,
                    "phoneNumber": event.phoneNumber,
                    "eventType": event.eventType,
                    "date": event.date,
                    "relationship": event.relationship,
                    "amount": event.amount,
                    "memo": event.memo ?? ""
                ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateEvent(let eventId, let event):
            let parameters: [String: Any] = [
                    "name": event.name,
                    "phoneNumber": event.phoneNumber,
                    "eventType": event.eventType,
                    "date": event.date,
                    "relationship": event.relationship,
                    "amount": event.amount,
                    "memo": event.memo ?? ""
                ]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["eventId": eventId]
            )
        case .deleteEvent(let eventId):
            let parameters = ["eventId": eventId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .fetchMyEvents:
            return .requestPlain
        case .fetchMyEventsSummary(let eventType, let date):
            let parameters = ["eventType": eventType, "date": date]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .fetchOthersEventsSummary:
            return .requestPlain
        case .fetchSingleEvent(let eventId):
            let parameters = ["eventId": eventId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .fetchCalendarEvents(let date):
            let parameters = ["date": date]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "\(accessToken)", "Authorization-refresh": "\(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
