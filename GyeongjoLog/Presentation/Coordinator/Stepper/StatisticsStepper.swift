import RxFlow
import RxCocoa

class StatisticsStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = StatisticsStep.navigateToStatisticsViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }

    func resetFlow() {
        self.steps.accept(StatisticsStep.endFlow)
    }
}
