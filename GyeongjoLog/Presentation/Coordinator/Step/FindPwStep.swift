import RxFlow

enum FindPwStep: Step, StepProtocol {
    case navigateToEnterEmailForFindPWViewController
    case navigateToEnterAuthNumberForFindPWViewController
    case navigateToEnterPasswordForFindPWViewController
    
    case presentToNoneJoinEmailAlertController
    case presentToDifferentCodeAlertController
    
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    
    case popViewController
    case completeFindPwFlow
}
