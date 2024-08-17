import RxFlow
import RxCocoa

enum EventHistoryStep: Step {
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
    
    // 뒤로가기
    case dismissSheetPresentationController
    case popViewController
}

