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
            // 뒤로가기
        case .popViewController:
            return popViewController()
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
    
    // 뒤로가기
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
