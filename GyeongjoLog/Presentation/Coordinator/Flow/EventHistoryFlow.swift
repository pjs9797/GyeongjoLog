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
        case .navigateToMyEventSummaryViewController(let eventType, let date):
            return navigateToMyEventSummaryViewController(eventType: eventType, date: date)
        case .navigateToAddEventViewController(let addEventFlow):
            return navigateToAddEventViewController(addEventFlow: addEventFlow)
        case .navigateToAddMyEventSummaryViewController(let eventType, let date):
            return navigateToAddMyEventSummaryViewController(eventType: eventType, date: date)
        case .navigateToDetailEventViewController(let addEventFlow, let event):
            return navigateToDetailEventViewController(addEventFlow: addEventFlow, event: event)
        case .navigateToAddNewEventTypeViewController:
            return navigateToAddNewEventTypeViewController()
        case .navigateToCalendarViewController:
            return navigateToCalendarViewController()
            
            // 프레젠트 - 필터
        case .presentToEventTypeFilterViewController(let filterRelay, let initialFilterType):
            return presentToEventTypeFilterViewController(filterRelay: filterRelay, initialFilterType: initialFilterType)
        case .presentToEventRelationshipFilterViewController(let filterRelay, let initialFilterType):
            return presentToEventRelationshipFilterViewController(filterRelay: filterRelay, initialFilterType: initialFilterType)
            
            // 프레젠트 - 추가 페이지
        case .presentToSelectEventTypeViewController(let eventTypeRelay, let initialEventType):
            return presentToSelectEventTypeViewController(eventTypeRelay: eventTypeRelay, initialEventType: initialEventType)
        case .presentToSelectEventDateViewController(let eventDateRelay, let initialDate):
            return presentToSelectEventDateViewController(eventDateRelay: eventDateRelay, initialDate: initialDate)
        case .presentToSelectRelationshipViewController(let eventRelationshipRelay):
            return presentToSelectRelationshipViewController(eventRelationshipRelay: eventRelationshipRelay)
            
            // 프레젠트 - 캘린더
        case .presentToSelectCalendarDateViewController(let eventDateRelay, let initialDate):
            return presentToSelectCalendarDateViewController(eventDateRelay: eventDateRelay, initialDate: initialDate)
            
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
        let compositeStepper = CompositeStepper(steppers: [myEventReactor, othersEventReactor,reactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper),
//            .contribute(withNextPresentable: viewController, withNextStepper: reactor),
//            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: compositeStepper)
        ])
    }
    
    private func navigateToMyEventSummaryViewController(eventType: String, date: String) -> FlowContributors {
        let reactor = MyEventSummaryReactor(eventUseCase: self.eventUseCase, eventType: eventType, date: date)
        let viewController = MyEventSummaryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddEventViewController(addEventFlow: AddEventFlow) -> FlowContributors {
        let reactor = AddEventReactor(eventUseCase: self.eventUseCase, addEventFlow: addEventFlow)
        let viewController = AddEventViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddMyEventSummaryViewController(eventType: String, date: String) -> FlowContributors {
        let reactor = AddMyEventSummaryReactor(eventUseCase: self.eventUseCase, eventType: eventType, date: date)
        let viewController = AddMyEventSummaryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailEventViewController(addEventFlow: AddEventFlow, event: Event) -> FlowContributors {
        let reactor = DatailEventReactor(eventUseCase: self.eventUseCase, addEventFlow: addEventFlow, event: event)
        let viewController = DetailEventViewController(with: reactor)
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
    private func presentToEventTypeFilterViewController(filterRelay: PublishRelay<String>, initialFilterType: String?) -> FlowContributors {
        let reactor = EventTypeFilterReactor(eventUseCase: self.eventUseCase, filterRelay: filterRelay, initialFilterType: initialFilterType)
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
    
    private func presentToEventRelationshipFilterViewController(filterRelay: PublishRelay<String>, initialFilterType: String?) -> FlowContributors {
        let reactor = EventRelationshipFilterReactor(eventUseCase: self.eventUseCase, filterRelay: filterRelay, initialFilterType: initialFilterType)
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
    private func presentToSelectEventTypeViewController(eventTypeRelay: PublishRelay<String>, initialEventType: String?) -> FlowContributors {
        let reactor = SelectEventTypeReactor(eventUseCase: self.eventUseCase, eventTypeRelay: eventTypeRelay, initialEventType: initialEventType)
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
    
    private func presentToSelectEventDateViewController(eventDateRelay: PublishRelay<String>, initialDate: String?) -> FlowContributors {
        let reactor = SelectEventDateReactor(eventUseCase: self.eventUseCase, eventDateRelay: eventDateRelay, initialDate: initialDate)
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
    
    // 프레젠트 - 캘린더
    private func presentToSelectCalendarDateViewController(eventDateRelay: PublishRelay<String>, initialDate: String?) -> FlowContributors {
        let reactor = SelectCalendarDateViewReactor(eventUseCase: self.eventUseCase, eventDateRelay: eventDateRelay, initialDate: initialDate)
        let viewController = SelectCalendarDateViewController(with: reactor)
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
