import RxFlow

protocol StepProtocol {}

enum AppStep: Step, StepProtocol {
    case navigateToOnBoardingViewController
    case navigateToBeginingViewController
    case navigateToLoginViewController
    case navigateToTabBarController
    
    case goToSignupFlow
    case goToFindPwFlow
    
    case completeSignupFlow
    case completeFindPwFlow
    
    case presentToInvalidLoginInfoAlertController
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    
    case popToRootViewController
    case popViewController
}

