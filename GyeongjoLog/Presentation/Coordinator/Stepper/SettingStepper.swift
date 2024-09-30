import RxFlow
import RxCocoa

class SettingStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = SettingStep.navigateToSettingViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }

    func resetFlow() {
        self.steps.accept(EventHistoryStep.endFlow)
    }
}
