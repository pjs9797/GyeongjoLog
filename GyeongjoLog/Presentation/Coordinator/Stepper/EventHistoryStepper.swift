import RxFlow
import RxCocoa

class EventHistoryStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = EventHistoryStep.navigateToHistoryViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }

    func resetFlow() {
        self.steps.accept(EventHistoryStep.endFlow)
    }
}
