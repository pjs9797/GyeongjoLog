import RxFlow
import RxCocoa

enum EventHistoryStep: Step, StepProtocol {
    // 푸시
    case navigateToHistoryViewController
    case navigateToMyEventSummaryViewController(eventType: String, date: String)
    case navigateToAddEventViewController(addEventFlow: AddEventFlow)
    case navigateToAddMyEventSummaryViewController(eventType: String, date: String)
    case navigateToDetailEventViewController(addEventFlow: AddEventFlow, event: Event)
    case navigateToAddNewEventTypeViewController
    case navigateToCalendarViewController
    
    // 프레젠트 - 필터
    case presentToEventTypeFilterViewController(filterRelay: PublishRelay<String>, initialFilterType: String?)
    case presentToEventRelationshipFilterViewController(filterRelay: PublishRelay<String>, initialFilterType: String?)
    
    // 프레젠트 - 추가 페이지
    case presentToSelectEventTypeViewController(eventTypeRelay: PublishRelay<String>, initialEventType: String?)
    case presentToSelectEventDateViewController(eventDateRelay: PublishRelay<String>, initialDate: String?)
    case presentToSelectRelationshipViewController(eventRelationshipRelay: PublishRelay<String>)
    
    // 프레젠트 - 캘린더
    case presentToSelectCalendarDateViewController(eventDateRelay: PublishRelay<String>, initialDate: String?)
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    
    // 뒤로가기
    case dismissSheetPresentationController
    case popViewController
    case endFlow
}

