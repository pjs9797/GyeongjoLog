import RxFlow
import RxCocoa

enum SettingStep: Step {
    // 푸시
    case navigateToSettingViewController
    case navigateToInquiryViewController
    case navigateToToPViewController
    
    // 뒤로가기
    case popViewController
}
