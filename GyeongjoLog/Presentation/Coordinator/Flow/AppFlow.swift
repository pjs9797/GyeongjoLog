import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let eventUseCase = EventUseCase(repository: EventRepository())
    
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
        let wordsNavigationController = UINavigationController()
        let settingNavigationController = UINavigationController()
        let eventHistoryFlow = EventHistoryFlow(with: eventHistoryNavigationController, eventUseCase: self.eventUseCase)
        
        Flows.use(eventHistoryFlow, when: .created) { [weak self] (eventHistoryNavigationController) in
            
            eventHistoryNavigationController.tabBarItem = UITabBarItem(title: "내역", image: ImageManager.icon_event_select?.withRenderingMode(.alwaysOriginal), tag: 0)

            tabBarController.viewControllers = [eventHistoryNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: eventHistoryFlow, withNextStepper: OneStepper(withSingleStep: EventHistoryStep.navigateToHistoryViewController)),
        ])
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
