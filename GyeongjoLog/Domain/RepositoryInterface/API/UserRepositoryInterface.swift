import RxSwift

protocol UserRepositoryInterface {
    func checkEmailIsExisted(email: String) -> Observable<String>
    func requestEmailAuthCode(email: String) -> Observable<String>
    func checkEmailAuthCode(email: String, code: String) -> Observable<String>
    func saveNewPw(email: String, password: String) -> Observable<String>
    func join(email: String, password: String) -> Observable<String>
    func login(email: String, password: String) -> Observable<String>
    func logout() -> Observable<String>
    func withdraw() -> Observable<String>
}
