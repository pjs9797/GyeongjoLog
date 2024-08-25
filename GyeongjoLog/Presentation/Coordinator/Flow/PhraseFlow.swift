import UIKit
import RxFlow
import RxCocoa

class PhraseFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PhraseStep else { return .none }
        switch step {
            // 푸시
        case .navigateToPhraseViewController:
            return navigateToPhraseViewController()
            
            // 뒤로가기
        case .popViewController:
            return popViewController()
        }
    }
    
    // 푸시
    private func navigateToPhraseViewController() -> FlowContributors {
        let reactor = PhraseReactor()
        let viewController = PhraseViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 뒤로가기
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
