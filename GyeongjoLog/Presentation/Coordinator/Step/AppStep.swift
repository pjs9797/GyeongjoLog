import RxFlow

enum AppStep: Step {
    case navigateToOnBoardingViewController
    case navigateToBeginingViewController
    case navigateToLoginViewController
    case navigateToTabBarController
    
    case navigateToEnterEmailForSignupViewController
    case navigateToEnterAuthNumberForSignupViewController
    case navigateToEnterPasswordForSignupViewController
    
    case popToRootViewController
    case popViewController
}
