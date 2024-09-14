import UIKit
import RxFlow
import RxCocoa

class StatisticsFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let statisticsLocalDBUseCase: StatisticsLocalDBUseCase
    
    init(with rootViewController: UINavigationController, statisticsLocalDBUseCase: StatisticsLocalDBUseCase) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.statisticsLocalDBUseCase = statisticsLocalDBUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? StatisticsStep else { return .none }
        switch step {
            // 푸시
        case .navigateToStatisticsViewController:
            return navigateToStatisticsViewController()
        case .navigateToDetailIndividualStatisticsViewController(let individualStatistics):
            return navigateToDetailIndividualStatisticsViewController(individualStatistics: individualStatistics)
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
            
            // 뒤로가기
        case .popViewController:
            return popViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.navigateToBeginingViewController)
        }
    }
    
    // 푸시
    private func navigateToStatisticsViewController() -> FlowContributors {
        let individualStatisticsReactor = IndividualStatisticsReactor(statisticsLocalDBUseCase: self.statisticsLocalDBUseCase)
        let individualStatisticsViewController = IndividualStatisticsViewController(with: individualStatisticsReactor)

        let monthlyStatisticsReactor = MonthlyStatisticsReactor(statisticsLocalDBUseCase: self.statisticsLocalDBUseCase)
        let monthlyStatisticsViewController = MonthlyStatisticsViewController(with: monthlyStatisticsReactor)
        
        let reactor = StatisticsReactor()
        let viewController = StatisticsViewController(with: reactor, viewControllers: [individualStatisticsViewController,monthlyStatisticsViewController])
        let compositeStepper = CompositeStepper(steppers: [individualStatisticsReactor, monthlyStatisticsReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper),
        ])
    }
    
    private func navigateToDetailIndividualStatisticsViewController(individualStatistics: IndividualStatistics) -> FlowContributors {
        let reactor = DetailIndividualStatisticsReactor(statisticsLocalDBUseCase: self.statisticsLocalDBUseCase, individualStatistics: individualStatistics)
        let viewController = DetailIndividualStatisticsViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트 공통 알람
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "네트워크 오류",
            message: "네트워크 연결을 확인해주세요",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToUnknownErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "알 수 없는 오류",
            message: "앱을 재실행해주세요",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToExpiredTokenErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "토큰 유효 기간 만료",
            message: "다시 로그인해주세요",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            let _ = self?.navigate(to: EventHistoryStep.endFlow)
        }
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    // 뒤로가기
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
