import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class SelectEventDateReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    let eventDateRelay: PublishRelay<String>
    
    init(eventUseCase: EventUseCase, eventDateRelay: PublishRelay<String>, initialDate: String?) {
        self.eventUseCase = eventUseCase
        self.eventDateRelay = eventDateRelay
        
        if let initialDate = initialDate {
            self.initialState = State(selectedDate: initialDate)
        } 
        else {
            let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            self.initialState = State(selectedDate: currentDate)
        }
    }
    
    enum Action {
        case dismissButtonTapped
        case selectDateButtonTapped
    }
    
    enum Mutation {
        case setInitialDate(String)
    }
    
    struct State {
        var selectedDate: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        case .selectDateButtonTapped:
            self.steps.accept(EventHistoryStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
