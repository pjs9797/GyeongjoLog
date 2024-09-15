import Moya
import Foundation

enum UserService {
    case checkDuplicateEmail(email: String)
    case sendAuthCode(email: String)
    case checkAuthCode(email: String, code: String)
    case saveNewPw(email: String, password: String)
    case join(email: String, password: String)
    case login(email: String, password: String)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkDuplicateEmail, .sendAuthCode, .checkAuthCode, .saveNewPw, .join, .login:
            return .post
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
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
