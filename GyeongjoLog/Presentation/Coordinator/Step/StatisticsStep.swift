import RxFlow
import RxCocoa

enum StatisticsStep: Step {
    // 푸시
    case navigateToStatisticsViewController
    case navigateToDetailIndividualStatisticsViewController(individualStatistics: IndividualStatistics)
    // 뒤로가기
    case popViewController
}
