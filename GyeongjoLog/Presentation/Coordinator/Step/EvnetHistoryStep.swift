import RxFlow
import RxCocoa

enum EventHistoryStep: Step {
    // 푸시
    case navigateToHistoryViewController
    case navigateToMyEventSummaryViewController(eventType: String, idList: [String])
    case navigateToAddEventViewController(addEventFlow: AddEventFlow)
    case navigateToAddNewEventTypeViewController
    case navigateToCalendarViewController
    
    // 프레젠트 - 필터
    case presentToEventTypeFilterViewController(filterRelay: PublishRelay<String>)
    case presentToEventRelationshipFilterViewController(filterRelay: PublishRelay<String>)
    
    // 프레젠트 - 추가 페이지
    case presentToSelectEventTypeViewController(eventTypeRelay: PublishRelay<String>)
    case presentToSelectEventDateViewController(eventDateRelay: PublishRelay<String>)
    case presentToSelectRelationshipViewController(eventRelationshipRelay: PublishRelay<String>)
    
    // 뒤로가기
    case dismissSheetPresentationController
    case popViewController
}

