import UIKit
import RxFlow
import RxCocoa

class StatisticsFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let statisticsUseCase: StatisticsUseCase
    
    init(with rootViewController: UINavigationController, statisticsUseCase: StatisticsUseCase) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.statisticsUseCase = statisticsUseCase
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
        let individualStatisticsReactor = IndividualStatisticsReactor(statisticsUseCase: self.statisticsUseCase)
        let individualStatisticsViewController = IndividualStatisticsViewController(with: individualStatisticsReactor)

        let monthlyStatisticsReactor = MonthlyStatisticsReactor(statisticsUseCase: self.statisticsUseCase)
        let monthlyStatisticsViewController = MonthlyStatisticsViewController(with: monthlyStatisticsReactor)
        
        let reactor = StatisticsReactor()
        let viewController = StatisticsViewController(with: reactor, viewControllers: [individualStatisticsViewController,monthlyStatisticsViewController])
        let compositeStepper = CompositeStepper(steppers: [individualStatisticsReactor, monthlyStatisticsReactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: compositeStepper),
            .contribute(withNextPresentable: viewController, withNextStepper: reactor),
        ])
    }
    
    private func navigateToDetailIndividualStatisticsViewController(individualStatistics: IndividualStatistics) -> FlowContributors {
        let reactor = DetailIndividualStatisticsReactor(statisticsUseCase: self.statisticsUseCase, individualStatistics: individualStatistics)
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
