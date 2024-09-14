import UIKit
import RxFlow

class SignupFlow: Flow {
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
        guard let step = step as? SignupStep else { return .none }
        switch step {
        case .navigateToEnterEmailForSignupViewController:
            return navigateToEnterEmailForSignupViewController()
        case .navigateToEnterAuthNumberForSignupViewController:
            return navigateToEnterAuthNumberForSignupViewController()
        case .navigateToEnterPasswordForSignupViewController:
            return navigateToEnterPasswordForSignupViewController()
        
        case .presentToDuplicateEmailAlertController:
            return presentToDuplicateEmailAlertController()
        case .presentToDifferentCodeAlertController:
            return presentToDifferentCodeAlertController()
            
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
            
        case .popViewController:
            return popViewController()
        case .completeSignupFlow:
            return completeSignupFlow()
        }
    }
    
    // 푸시
    private func navigateToEnterEmailForSignupViewController() -> FlowContributors {
        let reactor = EnterEmailForSignupReactor(userUseCase: self.userUseCase)
        let viewController = EnterEmailForSignupViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEnterAuthNumberForSignupViewController() -> FlowContributors {
        let reactor = EnterAuthNumberForSignupReactor(userUseCase: self.userUseCase)
        let viewController = EnterAuthNumberForSignupViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEnterPasswordForSignupViewController() -> FlowContributors {
        let reactor = EnterPasswordForSignupReactor(userUseCase: self.userUseCase)
        let viewController = EnterPasswordForSignupViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트 알람
    private func presentToDuplicateEmailAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "이메일 오류",
            message: "이미 가입된 이메일입니다",
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
    
    private func completeSignupFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
}
