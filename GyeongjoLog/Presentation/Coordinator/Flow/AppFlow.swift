import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    var eventHistoryFlow: EventHistoryFlow?
    var statisticsFlow: StatisticsFlow?
    var phraseFlow: PhraseFlow?
    var settingFlow: SettingFlow?
    
    private let eventLocalDBUseCase = EventLocalDBUseCase(repository: EventLocalDBRepository())
    private let statisticsLocalDBUseCase = StatisticsLocalDBUseCase(repository: StatisticsLocalDBRepository())
    private let userUseCase = UserUseCase(repository: UserRepository())
    private let eventUseCase = EventUseCase(repository: EventRepository(), eventTypeRepository: EventTypeRepository())
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
        case .navigateToBeginingViewController:
            return navigateToBeginingViewController()
        case .navigateToLoginViewController:
            return navigateToLoginViewController()
        case .navigateToTabBarController:
            return navigateToTabBarController()
            
        case .goToSignupFlow:
            return goToSignupFlow()
        case .goToFindPwFlow:
            return goToFindPwFlow()
            
        case .completeSignupFlow:
            return .none
        case .completeFindPwFlow:
            return .none
            
        case .presentToInvalidLoginInfoAlertController:
            return presentToInvalidLoginInfoAlertController()
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
            
        case .popToRootViewController:
            return popToRootViewController()
        case .popViewController:
            return popViewController()
        case .resetFlowAndNavigateToBeginingViewController:
            return resetFlowAndNavigateToBeginingViewController()
        }
    }
    
    private func navigateToOnBoardingViewController() -> FlowContributors {
        let reactor = OnBoardingReactor()
        let viewController = OnBoardingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToBeginingViewController() -> FlowContributors {
        let reactor = BeginingReactor()
        let viewController = BeginingViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToLoginViewController() -> FlowContributors {
        let reactor = LoginReactor(userUseCase: self.userUseCase)
        let viewController = LoginViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
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
        
        let eventHistoryStepper = EventHistoryStepper(initialStep: EventHistoryStep.navigateToHistoryViewController)
        let statisticsStepper = StatisticsStepper(initialStep: StatisticsStep.navigateToStatisticsViewController)
        let settingStepper = SettingStepper(initialStep: SettingStep.navigateToSettingViewController)
        
        self.eventHistoryFlow = EventHistoryFlow(with: eventHistoryNavigationController, eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, stepper: eventHistoryStepper)
        self.statisticsFlow = StatisticsFlow(with: statisticsNavigationController, statisticsUseCase: self.statisticsUseCase, statisticsLocalDBUseCase: self.statisticsLocalDBUseCase, stepper: statisticsStepper)
        self.phraseFlow = PhraseFlow(with: phraseNavigationController)
        self.settingFlow = SettingFlow(with: settingNavigationController, userUseCase: self.userUseCase, stepper: settingStepper)
        
        Flows.use(eventHistoryFlow!, statisticsFlow!, phraseFlow!, settingFlow!, when: .created) { [weak self] (eventHistoryNavigationController, statisticsNavigationController, phraseNavigationController, settingNavigationController) in
            
            eventHistoryNavigationController.tabBarItem = UITabBarItem(title: "내역", image: ImageManager.icon_event_select?.withRenderingMode(.alwaysOriginal), tag: 0)
            statisticsNavigationController.tabBarItem = UITabBarItem(title: "통계", image: ImageManager.icon_statistics_deselect?.withRenderingMode(.alwaysOriginal), tag: 1)
            phraseNavigationController.tabBarItem = UITabBarItem(title: "문구", image: ImageManager.icon_words_deselect?.withRenderingMode(.alwaysOriginal), tag: 2)
            settingNavigationController.tabBarItem = UITabBarItem(title: "설정", image: ImageManager.icon_setting_deselect?.withRenderingMode(.alwaysOriginal), tag: 3)

            tabBarController.viewControllers = [eventHistoryNavigationController,statisticsNavigationController,phraseNavigationController,settingNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: eventHistoryFlow!, withNextStepper: eventHistoryStepper),
            .contribute(withNextPresentable: statisticsFlow!, withNextStepper: statisticsStepper),
            .contribute(withNextPresentable: phraseFlow!, withNextStepper: OneStepper(withSingleStep: PhraseStep.navigateToPhraseViewController)),
            .contribute(withNextPresentable: settingFlow!, withNextStepper: settingStepper),
        ])
    }
    
    private func goToSignupFlow() -> FlowContributors {
        let signupFlow = SignupFlow(with: self.rootViewController, userUseCase: self.userUseCase)
        
        return .one(flowContributor: .contribute(withNextPresentable: signupFlow, withNextStepper: OneStepper(withSingleStep: SignupStep.navigateToEnterEmailForSignupViewController)))
    }
    
    private func goToFindPwFlow() -> FlowContributors {
        let findPwFlow = FindPwFlow(with: self.rootViewController, userUseCase: self.userUseCase)
        
        return .one(flowContributor: .contribute(withNextPresentable: findPwFlow, withNextStepper: OneStepper(withSingleStep: FindPwStep.navigateToEnterEmailForFindPWViewController)))
    }
    
    private func presentToInvalidLoginInfoAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "로그인 정보 오류",
            message: "이메일이나 비밀번호를 확인해주세요",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
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
    
    private func popToRootViewController() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func resetFlowAndNavigateToBeginingViewController() -> FlowContributors {
        
        self.eventHistoryFlow = nil
        self.statisticsFlow = nil
        self.phraseFlow = nil
        self.settingFlow = nil
        
        let reactor = BeginingReactor()
        let viewController = BeginingViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
