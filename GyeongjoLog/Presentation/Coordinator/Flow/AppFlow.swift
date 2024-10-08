import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let eventLocalDBUseCase = EventLocalDBUseCase(repository: EventLocalDBRepository())
    private let statisticsLocalDBUseCase = StatisticsLocalDBUseCase(repository: StatisticsLocalDBRepository())
    
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
        let eventHistoryFlow = EventHistoryFlow(with: eventHistoryNavigationController, eventLocalDBUseCase: self.eventLocalDBUseCase)
        let statisticsFlow = StatisticsFlow(with: statisticsNavigationController, statisticsLocalDBUseCase: self.statisticsLocalDBUseCase)
        let phraseFlow = PhraseFlow(with: phraseNavigationController)
        let settingFlow = SettingFlow(with: settingNavigationController)
        
        Flows.use(eventHistoryFlow, statisticsFlow, phraseFlow, settingFlow, when: .created) { [weak self] (eventHistoryNavigationController, statisticsNavigationController, phraseNavigationController, settingNavigationController) in
            
            eventHistoryNavigationController.tabBarItem = UITabBarItem(title: "내역", image: ImageManager.icon_event_select?.withRenderingMode(.alwaysOriginal), tag: 0)
            statisticsNavigationController.tabBarItem = UITabBarItem(title: "통계", image: ImageManager.icon_statistics_deselect?.withRenderingMode(.alwaysOriginal), tag: 1)
            phraseNavigationController.tabBarItem = UITabBarItem(title: "문구", image: ImageManager.icon_words_deselect?.withRenderingMode(.alwaysOriginal), tag: 2)
            settingNavigationController.tabBarItem = UITabBarItem(title: "설정", image: ImageManager.icon_setting_deselect?.withRenderingMode(.alwaysOriginal), tag: 3)

            tabBarController.viewControllers = [eventHistoryNavigationController,statisticsNavigationController,phraseNavigationController,settingNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: eventHistoryFlow, withNextStepper: OneStepper(withSingleStep: EventHistoryStep.navigateToHistoryViewController)),
            .contribute(withNextPresentable: statisticsFlow, withNextStepper: OneStepper(withSingleStep: StatisticsStep.navigateToStatisticsViewController)),
            .contribute(withNextPresentable: phraseFlow, withNextStepper: OneStepper(withSingleStep: PhraseStep.navigateToPhraseViewController)),
            .contribute(withNextPresentable: settingFlow, withNextStepper: OneStepper(withSingleStep: SettingStep.navigateToSettingViewController)),
        ])
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
