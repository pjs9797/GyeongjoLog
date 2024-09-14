import Moya
import Foundation
import RxMoya
import RxSwift

class EventTypeRepository: EventTypeRepositoryInterface {
    private let provider = MoyaProvider<EventTypeService>()
    
    func fetchEventTypes() -> Observable<[EventType]> {
        return provider.rx.request(.fetchEventTypes)
            .filterSuccessfulStatusCodes()
            .map(EventTypeResponseDTO.self)
            .map{ EventTypeResponseDTO.toEventTypes(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func addEventType(eventType: String, color: String) -> Observable<String> {
        return provider.rx.request(.addEventType(eventType: eventType, color: color))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
