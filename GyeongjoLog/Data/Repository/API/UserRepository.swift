import Moya
import Foundation
import RxMoya
import RxSwift

class UserRepository: UserRepositoryInterface {
    private let provider = MoyaProvider<UserService>()
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return provider.rx.request(.checkDuplicateEmail(email: email))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func requestEmailAuthCode(email: String) -> Observable<String> {
        return provider.rx.request(.sendAuthCode(email: email))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func checkEmailAuthCode(email: String, code: String) -> Observable<String> {
        return provider.rx.request(.checkAuthCode(email: email, code: code))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func saveNewPw(email: String, password: String) -> Observable<String> {
        return provider.rx.request(.saveNewPw(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func join(email: String, password: String) -> Observable<String> {
        return provider.rx.request(.join(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func login(email: String, password: String) -> Observable<String> {
        return provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { response in
                // 응답 헤더에서 토큰 추출
                if let httpResponse = response.response,
                   let accessToken = httpResponse.allHeaderFields["Authorization"] as? String,
                   let refreshToken = httpResponse.allHeaderFields["Authorization-Refresh"] as? String {
                    // 토큰 저장
                    TokenManager.shared.saveAccessToken(accessToken)
                    TokenManager.shared.saveRefreshToken(refreshToken)
                    if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
                        print(["Authorization": "\(accessToken)", "Authorization-refresh": "\(refreshToken)"])
                    }
                }
            })
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
