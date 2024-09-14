import RxFlow

enum SignupStep: Step, StepProtocol {
    case navigateToEnterEmailForSignupViewController
    case navigateToEnterAuthNumberForSignupViewController
    case navigateToEnterPasswordForSignupViewController
    
    case presentToDuplicateEmailAlertController
    case presentToDifferentCodeAlertController
    
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    
    case popViewController
    case completeSignupFlow
}
