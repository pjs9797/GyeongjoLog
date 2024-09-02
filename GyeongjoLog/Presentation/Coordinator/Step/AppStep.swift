import RxFlow

enum AppStep: Step {
    case navigateToOnBoardingViewController
    case navigateToBeginingViewController
    case navigateToLoginViewController
    case navigateToTabBarController
    
    case navigateToEnterEmailForSignupViewController
    case navigateToEnterAuthNumberForSignupViewController
    case navigateToEnterPasswordForSignupViewController
    
    case navigateToEnterEmailForFindPWViewController
    case navigateToEnterAuthNumberForFindPWViewController
    case navigateToEnterPasswordForFindPWViewController
    
    case popToRootViewController
    case popViewController
}
