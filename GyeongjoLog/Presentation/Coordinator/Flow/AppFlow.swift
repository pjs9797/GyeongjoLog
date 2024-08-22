import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let eventUseCase = EventUseCase(repository: EventRepository())
    private let statisticsUseCase = StatisticsUseCase(repository: StatisticsRepository())
    
    lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .navigateToOnBoardingViewController:
            return navigateToOnBoardingViewController()
        case .navigateToTabBarController:
            return navigateToTabBarController()
        }
    }
    
    private func navigateToOnBoardingViewController() -> FlowContributors {
        let reactor = OnBoardingReactor()
        let viewController = OnBoardingViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTabBarController() -> FlowContributors {
        let tabBarController = TabBarController()
        self.rootViewController.isNavigationBarHidden = true
        let eventHistoryNavigationController = UINavigationController()
        let statisticsNavigationController = UINavigationController()
        let phraseNavigationController = UINavigationController()
        let settingNavigationController = UINavigationController()
        let eventHistoryFlow = EventHistoryFlow(with: eventHistoryNavigationController, eventUseCase: self.eventUseCase)
        let statisticsFlow = StatisticsFlow(with: statisticsNavigationController, statisticsUseCase: self.statisticsUseCase)
        let phraseFlow = PhraseFlow(with: phraseNavigationController)
        
        Flows.use(eventHistoryFlow, statisticsFlow, phraseFlow, when: .created) { [weak self] (eventHistoryNavigationController, statisticsNavigationController, phraseNavigationController) in
            
            eventHistoryNavigationController.tabBarItem = UITabBarItem(title: "내역", image: ImageManager.icon_event_select?.withRenderingMode(.alwaysOriginal), tag: 0)
            statisticsNavigationController.tabBarItem = UITabBarItem(title: "통계", image: ImageManager.icon_statistics_deselect?.withRenderingMode(.alwaysOriginal), tag: 1)
            phraseNavigationController.tabBarItem = UITabBarItem(title: "문구", image: ImageManager.icon_words_deselect?.withRenderingMode(.alwaysOriginal), tag: 2)

            tabBarController.viewControllers = [eventHistoryNavigationController,statisticsNavigationController,phraseNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: eventHistoryFlow, withNextStepper: OneStepper(withSingleStep: EventHistoryStep.navigateToHistoryViewController)),
            .contribute(withNextPresentable: statisticsFlow, withNextStepper: OneStepper(withSingleStep: StatisticsStep.navigateToStatisticsViewController)),
            .contribute(withNextPresentable: phraseFlow, withNextStepper: OneStepper(withSingleStep: PhraseStep.navigateToPhraseViewController)),
        ])
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
