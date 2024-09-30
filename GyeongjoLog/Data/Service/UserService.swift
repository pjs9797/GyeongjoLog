import Moya
import Foundation

enum UserService {
    case checkDuplicateEmail(email: String)
    case sendAuthCode(email: String)
    case checkAuthCode(email: String, code: String)
    case saveNewPw(email: String, password: String)
    case join(email: String, password: String)
    case login(email: String, password: String)
    case logout
    case withdraw
}

extension UserService: TargetType {
    var baseURL: URL { return URL(string: "http://localhost:8080/user/")! }
    var path: String {
        switch self {
        case .checkDuplicateEmail:
            return "checkDuplicateEmail"
        case .sendAuthCode:
            return "sendAuthCode"
        case .checkAuthCode:
            return "checkAuthCode"
        case .saveNewPw:
            return "saveNewPw"
        case .join:
            return "join"
        case .login:
            return "login"
        case .logout:
            return "logout"
        case .withdraw:
            return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkDuplicateEmail, .sendAuthCode, .checkAuthCode, .saveNewPw, .join, .login:
            return .post
        case .logout, .withdraw:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .checkDuplicateEmail(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendAuthCode(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .checkAuthCode(let email, let code):
            let parameters = ["email": email, "authNum": code]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .saveNewPw(let email, let password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .join(let email, let password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .login(let email, let password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .logout, .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .logout, .withdraw:
            if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
                return ["Content-Type": "application/json",
                        "Authorization": "\(accessToken)",
                        "Authorization-Refresh": "\(refreshToken)"]
            }
        default:
            return ["Content-Type": "application/json"]
        }
        return ["Content-Type": "application/json"]
    }

}
