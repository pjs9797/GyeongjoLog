import Foundation
import Moya

class ErrorHandler {
    static func handle<T>(error: Error, stepsHandler: (T) -> Void) where T: StepProtocol {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .underlying(let nsError as NSError, _):
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    if T.self is AppStep.Type {
                        stepsHandler(AppStep.presentToNetworkErrorAlertController as! T)
                    }
                    else if T.self is SignupStep.Type {
                        stepsHandler(SignupStep.presentToNetworkErrorAlertController as! T)
                    } 
                    else if T.self is FindPwStep.Type {
                        stepsHandler(FindPwStep.presentToNetworkErrorAlertController as! T)
                    }
                    else if T.self is EventHistoryStep.Type {
                        stepsHandler(EventHistoryStep.presentToNetworkErrorAlertController as! T)
                    }
                    else if T.self is StatisticsStep.Type {
                        stepsHandler(StatisticsStep.presentToNetworkErrorAlertController as! T)
                    }
                    else if T.self is SettingStep.Type {
                        stepsHandler(SettingStep.presentToNetworkErrorAlertController as! T)
                    }
                }
            case .statusCode(let response):
                if response.statusCode == 403 {
                    if T.self is EventHistoryStep.Type {
                        stepsHandler(EventHistoryStep.presentToExpiredTokenErrorAlertController as! T)
                    }
                    else if T.self is StatisticsStep.Type {
                        stepsHandler(StatisticsStep.presentToExpiredTokenErrorAlertController as! T)
                    }
                    else if T.self is SettingStep.Type {
                        stepsHandler(SettingStep.presentToExpiredTokenErrorAlertController as! T)
                    }
                }
                else {
                    if T.self is AppStep.Type {
                        stepsHandler(AppStep.presentToUnknownErrorAlertController as! T)
                    }
                    else if T.self is SignupStep.Type {
                        stepsHandler(SignupStep.presentToUnknownErrorAlertController as! T)
                    }
                    else if T.self is FindPwStep.Type {
                        stepsHandler(FindPwStep.presentToUnknownErrorAlertController as! T)
                    }
                    else if T.self is EventHistoryStep.Type {
                        stepsHandler(EventHistoryStep.presentToUnknownErrorAlertController as! T)
                    }
                    else if T.self is StatisticsStep.Type {
                        stepsHandler(StatisticsStep.presentToUnknownErrorAlertController as! T)
                    }
                    else if T.self is SettingStep.Type {
                        stepsHandler(SettingStep.presentToUnknownErrorAlertController as! T)
                    }
                }
            default:
                if T.self is AppStep.Type {
                    stepsHandler(AppStep.presentToUnknownErrorAlertController as! T)
                }
                else if T.self is SignupStep.Type {
                    stepsHandler(SignupStep.presentToUnknownErrorAlertController as! T)
                }
                else if T.self is FindPwStep.Type {
                    stepsHandler(FindPwStep.presentToUnknownErrorAlertController as! T)
                }
                else if T.self is EventHistoryStep.Type {
                    stepsHandler(EventHistoryStep.presentToUnknownErrorAlertController as! T)
                }
                else if T.self is StatisticsStep.Type {
                    stepsHandler(StatisticsStep.presentToUnknownErrorAlertController as! T)
                }
                else if T.self is SettingStep.Type {
                    stepsHandler(SettingStep.presentToUnknownErrorAlertController as! T)
                }
            }
        } else {
            if T.self is AppStep.Type {
                stepsHandler(AppStep.presentToUnknownErrorAlertController as! T)
            }
            else if T.self is SignupStep.Type {
                stepsHandler(SignupStep.presentToUnknownErrorAlertController as! T)
            } 
            else if T.self is FindPwStep.Type {
                stepsHandler(FindPwStep.presentToUnknownErrorAlertController as! T)
            }
            else if T.self is EventHistoryStep.Type {
                stepsHandler(EventHistoryStep.presentToUnknownErrorAlertController as! T)
            }
            else if T.self is StatisticsStep.Type {
                stepsHandler(StatisticsStep.presentToUnknownErrorAlertController as! T)
            }
            else if T.self is SettingStep.Type {
                stepsHandler(SettingStep.presentToUnknownErrorAlertController as! T)
            }
        }
    }
}
