import RxFlow
import RxCocoa

enum SettingStep: Step, StepProtocol {
    // 푸시
    case navigateToSettingViewController
    case navigateToInquiryViewController
    case navigateToToPViewController
    
    // 프레젠트
    case presentToLogoutAlertController(reactor: SettingReactor)
    case presentToWithdrawAlertController(reactor: SettingReactor)
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    
    // 뒤로가기
    case popViewController
    
    case endFlow
}
