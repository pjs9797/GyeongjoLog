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
        case .navigateToMyEventSummaryViewController(let eventType, let idList):
            return navigateToMyEventSummaryViewController(eventType: eventType, idList: idList)
        case .navigateToAddEventViewController:
            return navigateToAddEventViewController()
        case .navigateToAddNewEventTypeViewController:
            return navigateToAddNewEventTypeViewController()
        case .navigateToCalendarViewController:
            return navigateToCalendarViewController()
            
            // 프레젠트 - 필터
        case .presentToEventTypeFilterViewController(let filterRelay):
            return presentToEventTypeFilterViewController(filterRelay: filterRelay)
        case .presentToEventRelationshipFilterViewController(let filterRelay):
            return presentToEventRelationshipFilterViewController(filterRelay: filterRelay)
            
            // 프레젠트 - 추가 페이지
        case .presentToSelectEventTypeViewController(let eventTypeRelay):
            return presentToSelectEventTypeViewController(eventTypeRelay: eventTypeRelay)
        case .presentToSelectEventDateViewController(let eventDateRelay):
            return presentToSelectEventDateViewController(eventDateRelay: eventDateRelay)
        case .presentToSelectRelationshipViewController(let eventRelationshipRelay):
            return presentToSelectRelationshipViewController(eventRelationshipRelay: eventRelationshipRelay)
            
            // 뒤로가기
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        }
    }
    
    // 푸시
    private func navigateToHistoryViewController() -> FlowContributors {
        let myEventReactor = MyEventReactor(eventUseCase: self.eventUseCase)
        let myEventViewController = MyEventViewController(with: myEventReactor)
        
        let othersEventReactor = OthersEventReactor(eventUseCase: self.eventUseCase)
        let othersEventViewController = OthersEventViewController(with: othersEventReactor)
        
        let reactor = EventHistoryReactor()
        let viewController = EventHistoryViewController(with: reactor, viewControllers: [myEventViewController,othersEventViewController])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: myEventReactor),
            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: othersEventReactor),
            .contribute(withNextPresentable: viewController, withNextStepper: reactor),
//            .contribute(withNextPresentable: myEventViewController, withNextStepper: myEventReactor),
//            .contribute(withNextPresentable: othersEventViewController, withNextStepper: othersEventReactor),
            
        ])
    }
    
    private func navigateToMyEventSummaryViewController(eventType: String, idList: [String]) -> FlowContributors {
        let reactor = MyEventSummaryReactor(eventUseCase: self.eventUseCase, eventType: eventType, idList: idList)
        let viewController = MyEventSummaryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
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
    
    private func navigateToAddNewEventTypeViewController() -> FlowContributors {
        let reactor = AddNewEventTypeReactor(eventUseCase: self.eventUseCase)
        let viewController = AddNewEventTypeViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToCalendarViewController() -> FlowContributors {
        let reactor = CalendarReactor(eventUseCase: self.eventUseCase)
        let viewController = CalendarViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트 - 필터
    private func presentToEventTypeFilterViewController(filterRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = EventTypeFilterReactor(eventUseCase: self.eventUseCase, filterRelay: filterRelay)
        let viewController = EventTypeFilterViewController(with: reactor)
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
    
    private func presentToEventRelationshipFilterViewController(filterRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = EventRelationshipFilterReactor(eventUseCase: self.eventUseCase, filterRelay: filterRelay)
        let viewController = EventRelationshipFilterViewController(with: reactor)
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
    
    // 프레젠트 - 추가 페이지
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
    
    private func presentToSelectEventDateViewController(eventDateRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectEventDateReactor(eventUseCase: self.eventUseCase, eventDateRelay: eventDateRelay)
        let viewController = SelectEventDateViewController(with: reactor)
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
    
    // 뒤로가기
    private func dismissSheetPresentationController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
