import RxFlow
import RxCocoa

enum StatisticsStep: Step {
    // 푸시
    case navigateToStatisticsViewController
    case navigateToDetailIndividualStatisticsViewController(individualStatistics: IndividualStatistics)
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    
    // 뒤로가기
    case popViewController
    case endFlow
}
