import UIKit
import RxFlow
import RxCocoa

class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let userUseCase: UserUseCase
    private let stepper: SettingStepper
    
    init(with rootViewController: UINavigationController, userUseCase: UserUseCase, stepper: SettingStepper) {
        self.rootViewController = rootViewController
        self.userUseCase = userUseCase
        self.stepper = stepper
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingStep else { return .none }
        switch step {
            // 푸시
        case .navigateToSettingViewController:
            return navigateToSettingViewController()
        case .navigateToInquiryViewController:
            return navigateToInquiryViewController()
        case .navigateToToPViewController:
            return navigateToToPViewController()
            
            // 프레젠트
        case .presentToLogoutAlertController(let reactor):
            return presentToLogoutAlertController(reactor: reactor)
        case .presentToWithdrawAlertController(let reactor):
            return presentToWithdrawAlertController(reactor: reactor)
            
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
            return .end(forwardToParentFlowWithStep: AppStep.resetFlowAndNavigateToBeginingViewController)
        }
    }
    
    // 푸시
    private func navigateToSettingViewController() -> FlowContributors {
        let reactor = SettingReactor(userUseCase: self.userUseCase)
        let viewController = SettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToInquiryViewController() -> FlowContributors {
        let reactor = InquiryReactor()
        let viewController = InquiryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToToPViewController() -> FlowContributors {
        let reactor = ToPReactor()
        let viewController = ToPViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트
    private func presentToLogoutAlertController(reactor: SettingReactor) -> FlowContributors {
        let alertController = UIAlertController(title: "정말 로그아웃을 하시겠습니까?",
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            reactor.action.onNext(.logout)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToWithdrawAlertController(reactor: SettingReactor) -> FlowContributors {
        let alertController = UIAlertController(title: "정말 회원 탈퇴를 하시겠습니까?",
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            reactor.action.onNext(.withdraw)
        }
        alertController.addAction(noAction)
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
    
    private func presentToExpiredTokenErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: "토큰 유효 기간 만료",
            message: "다시 로그인해주세요",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.stepper.resetFlow()
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
