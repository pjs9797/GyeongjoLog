import UIKit
import RxFlow

class FindPwFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let userUseCase: UserUseCase
    
    init(with rootViewController: UINavigationController, userUseCase: UserUseCase) {
        self.rootViewController = rootViewController
        self.userUseCase = userUseCase
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FindPwStep else { return .none }
        switch step {
        case .navigateToEnterEmailForFindPWViewController:
            return navigateToEnterEmailForFindPWViewController()
        case .navigateToEnterAuthNumberForFindPWViewController:
            return navigateToEnterAuthNumberForFindPWViewController()
        case .navigateToEnterPasswordForFindPWViewController:
            return navigateToEnterPasswordForFindPWViewController()
            
        case .presentToNoneJoinEmailAlertController:
            return presentToNoneJoinEmailAlertController()
        case .presentToDifferentCodeAlertController:
            return presentToDifferentCodeAlertController()
        
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        
        case .popViewController:
            return popViewController()
        case .completeFindPwFlow:
            return completeFindPwFlow()
        }
    }
    
    // 푸시
    private func navigateToEnterEmailForFindPWViewController() -> FlowContributors {
        let reactor = EnterEmailForFindPWReactor(userUseCase: self.userUseCase)
        let viewController = EnterEmailForFindPWViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEnterAuthNumberForFindPWViewController() -> FlowContributors {
        let reactor = EnterAuthNumberForFindPWReactor(userUseCase: self.userUseCase)
        let viewController = EnterAuthNumberForFindPWViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEnterPasswordForFindPWViewController() -> FlowContributors {
        let reactor = EnterPasswordForFindPWReactor(userUseCase: self.userUseCase)
        let viewController = EnterPasswordForFindPWViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트 알람
    private func presentToNoneJoinEmailAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "이메일 오류",
            message: "가입되지 않은 이메일입니다",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToDifferentCodeAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "잘못된 인증번호",
            message: "인증번호를 확인해주세요",
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
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func completeFindPwFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.completeFindPwFlow)
    }
}
