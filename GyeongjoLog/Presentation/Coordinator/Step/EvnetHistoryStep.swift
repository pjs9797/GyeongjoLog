import RxFlow
import RxCocoa

enum EventHistoryStep: Step {
    case navigateToHistoryViewController
    case navigateToMyEventSummaryViewController(eventType: String, idList: [String])
    case navigateToAddEventViewController
    case navigateToCalendarViewController
    case presentToSelectEventTypeViewController(eventTypeRelay: PublishRelay<String>)
    case presentToSelectDateViewController(eventDateRelay: PublishRelay<String>)
    case presentToSelectRelationshipViewController(eventRelationshipRelay: PublishRelay<String>)
    case dismissSheetPresentationController
    case popViewController
}

