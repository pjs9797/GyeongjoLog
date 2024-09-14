import Moya
import Foundation
import RxMoya
import RxSwift

class EventRepository: EventRepositoryInterface {
    private let provider = MoyaProvider<EventService>()
    
    func addEvent(event: Event) -> Observable<String> {
        return provider.rx.request(.addEvent(event: event))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func updateEvent(eventId: String, event: Event) -> Observable<String> {
        return provider.rx.request(.updateEvent(eventId: eventId, event: event))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func deleteEvent(eventId: String) -> Observable<String> {
        return provider.rx.request(.deleteEvent(eventId: eventId))
            .filterSuccessfulStatusCodes()
            .map(ResponseDTO.self)
            .map{ ResponseDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchMyEvents() -> Observable<[Event]> {
        return provider.rx.request(.fetchMyEvents)
            .filterSuccessfulStatusCodes()
            .map(EventsResponseDTO.self)
            .map{ EventsResponseDTO.toEvents(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchMyEventsSummary(eventType: String, date: String) -> Observable<[Event]> {
        return provider.rx.request(.fetchMyEventsSummary(eventType: eventType, date: date))
            .filterSuccessfulStatusCodes()
            .map(EventsResponseDTO.self)
            .map{ EventsResponseDTO.toEvents(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchOthersEventsSummary() -> Observable<[Event]> {
        return provider.rx.request(.fetchOthersEventsSummary)
            .filterSuccessfulStatusCodes()
            .map(EventsResponseDTO.self)
            .map{ EventsResponseDTO.toEvents(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchSingleEvent(eventId: String) -> Observable<Event> {
        return provider.rx.request(.fetchSingleEvent(eventId: eventId))
            .filterSuccessfulStatusCodes()
            .map(EventResponseDTO.self)
            .map{ EventResponseDTO.toEvent(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCalendarEvents(date: String) -> Observable<[Event]> {
        return provider.rx.request(.fetchCalendarEvents(date: date))
            .filterSuccessfulStatusCodes()
            .map(EventsResponseDTO.self)
            .map{ EventsResponseDTO.toEvents(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
