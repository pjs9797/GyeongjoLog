import RxSwift
import Foundation

class UserUseCase {
    private let repository: UserRepositoryInterface
    
    init(repository: UserRepositoryInterface) {
        self.repository = repository
    }
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return repository.checkEmailIsExisted(email: email)
    }
    
    func requestEmailAuthCode(email: String) -> Observable<String> {
        return repository.requestEmailAuthCode(email: email)
    }
    
    func checkEmailAuthCode(email: String, code: String) -> Observable<String> {
        return repository.checkEmailAuthCode(email: email, code: code)
    }
    
    func saveNewPw(email: String, password: String) -> Observable<String> {
        return repository.saveNewPw(email: email, password: password)
    }
    
    func join(email: String, password: String) -> Observable<String> {
        return repository.join(email: email, password: password)
    }
    
    func login(email: String, password: String) -> Observable<String> {
        return repository.login(email: email, password: password)
    }
}
