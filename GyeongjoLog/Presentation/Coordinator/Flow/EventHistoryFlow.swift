import UIKit
import RxFlow
import RxCocoa

class EventHistoryFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let eventUseCase: EventUseCase
    
    init(with rootViewController: UINavigationController, eventUseCase: EventUseCase) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.eventUseCase = eventUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? EventHistoryStep else { return .none }
        switch step {
            // 푸시
        case .navigateToHistoryViewController:
            return navigateToHistoryViewController()
        case .navigateToAddEventViewController:
            return navigateToAddEventViewController()
            // 프레젠트
        case .presentToSelectEventTypeViewController(let eventTypeRelay):
            return presentToSelectEventTypeViewController(eventTypeRelay: eventTypeRelay)
        case .presentToSelectDateViewController(let eventDateRelay):
            return presentToSelectDateViewController(eventDateRelay: eventDateRelay)
        case .presentToSelectRelationshipViewController(let eventRelationshipRelay):
            return presentToSelectRelationshipViewController(eventRelationshipRelay: eventRelationshipRelay)
            // 뒤로가기
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToHistoryViewController() -> FlowContributors {
        let reactor = EventHistoryReactor(eventUseCase: self.eventUseCase)
        let viewController = EventHistoryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddEventViewController() -> FlowContributors {
        let reactor = AddEventReactor(eventUseCase: self.eventUseCase)
        let viewController = AddEventViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectEventTypeViewController(eventTypeRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectEventTypeReactor(eventUseCase: self.eventUseCase, eventTypeRelay: eventTypeRelay)
        let viewController = SelectEventTypeViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 340*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectDateViewController(eventDateRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectDateReactor(eventUseCase: self.eventUseCase, eventDateRelay: eventDateRelay)
        let viewController = SelectDateViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 340*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectRelationshipViewController(eventRelationshipRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectRelationshipReactor(eventUseCase: self.eventUseCase, eventRelationshipRelay: eventRelationshipRelay)
        let viewController = SelectRelationshipViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 340*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func dismissSheetPresentationController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
