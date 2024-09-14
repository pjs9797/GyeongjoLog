import UIKit
import RxFlow
import RxCocoa

class EventHistoryFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let eventUseCase: EventUseCase
    private let eventLocalDBUseCase: EventLocalDBUseCase
    
    init(with rootViewController: UINavigationController, eventUseCase: EventUseCase, eventLocalDBUseCase: EventLocalDBUseCase) {
        self.rootViewController = rootViewController
        self.eventUseCase = eventUseCase
        self.eventLocalDBUseCase = eventLocalDBUseCase
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
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
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
            
            // 뒤로가기
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.navigateToBeginingViewController)
        }
    }
    
    // 푸시
    private func navigateToHistoryViewController() -> FlowContributors {
        let myEventReactor = MyEventReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase)
        let myEventViewController = MyEventViewController(with: myEventReactor)
        
        let othersEventReactor = OthersEventReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase)
        let othersEventViewController = OthersEventViewController(with: othersEventReactor)
        
        let reactor = EventHistoryReactor()
        let viewController = EventHistoryViewController(with: reactor, viewControllers: [myEventViewController,othersEventViewController])
        let compositeStepper = CompositeStepper(steppers: [myEventReactor, othersEventReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper),
//            .contribute(withNextPresentable: viewController, withNextStepper: reactor),
//            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: compositeStepper)
        ])
    }
    
    private func navigateToMyEventSummaryViewController(eventType: String, date: String) -> FlowContributors {
        let reactor = MyEventSummaryReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, eventType: eventType, date: date)
        let viewController = MyEventSummaryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddEventViewController(addEventFlow: AddEventFlow) -> FlowContributors {
        let reactor = AddEventReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, addEventFlow: addEventFlow)
        let viewController = AddEventViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddMyEventSummaryViewController(eventType: String, date: String) -> FlowContributors {
        let reactor = AddMyEventSummaryReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, eventType: eventType, date: date)
        let viewController = AddMyEventSummaryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailEventViewController(addEventFlow: AddEventFlow, event: Event) -> FlowContributors {
        let reactor = DatailEventReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, addEventFlow: addEventFlow, event: event)
        let viewController = DetailEventViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddNewEventTypeViewController() -> FlowContributors {
        let reactor = AddNewEventTypeReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase)
        let viewController = AddNewEventTypeViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToCalendarViewController() -> FlowContributors {
        let reactor = CalendarReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase)
        let viewController = CalendarViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 프레젠트 - 필터
    private func presentToEventTypeFilterViewController(filterRelay: PublishRelay<String>, initialFilterType: String?) -> FlowContributors {
        let reactor = EventTypeFilterReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, filterRelay: filterRelay, initialFilterType: initialFilterType)
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
        let reactor = EventRelationshipFilterReactor(filterRelay: filterRelay, initialFilterType: initialFilterType)
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
        let reactor = SelectEventTypeReactor(eventUseCase: self.eventUseCase, eventLocalDBUseCase: self.eventLocalDBUseCase, eventTypeRelay: eventTypeRelay, initialEventType: initialEventType)
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
        let reactor = SelectEventDateReactor(eventDateRelay: eventDateRelay, initialDate: initialDate)
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
        let reactor = SelectRelationshipReactor(eventRelationshipRelay: eventRelationshipRelay)
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
        let reactor = SelectCalendarDateViewReactor(eventDateRelay: eventDateRelay, initialDate: initialDate)
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
            let _ = self?.navigate(to: EventHistoryStep.endFlow)
        }
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
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
