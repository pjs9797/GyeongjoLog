//
//  ErrorHandler.swift
//  GyeongjoLog
//
//  Created by 박중선 on 9/12/24.
//

import Foundation
import Moya

class ErrorHandler {
    // 스텝 타입을 제네릭으로 처리
    static func handle<T>(error: Error, stepsHandler: (T) -> Void) where T: StepProtocol {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .underlying(let nsError as NSError, _):
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    if let step = T.self as? AppStep.Type {
                        stepsHandler(AppStep.presentToNetworkErrorAlertController as! T)
                    }
                    else if let step = T.self as? SignupStep.Type {
                        stepsHandler(SignupStep.presentToNetworkErrorAlertController as! T)
                    } 
                    else if let step = T.self as? FindPwStep.Type {
                        stepsHandler(FindPwStep.presentToNetworkErrorAlertController as! T)
                    }
                    
                }
            case .statusCode(let response):
                return
//                if response.statusCode == 401 {
//                    if let step = T.self as? SignupStep.Type {
//                        stepsHandler(SignupStep.presentToUnauthorizedAlertController as! T)
//                    } else if let step = T.self as? SigninStep.Type {
//                        stepsHandler(SigninStep.presentToUnauthorizedAlertController as! T)
//                    }
//                } else {
//                    if let step = T.self as? SignupStep.Type {
//                        stepsHandler(SignupStep.presentToNetworkErrorAlertController as! T)
//                    } else if let step = T.self as? SigninStep.Type {
//                        stepsHandler(SigninStep.presentToNetworkErrorAlertController as! T)
//                    }
//                }
            default:
                if let step = T.self as? AppStep.Type {
                    stepsHandler(AppStep.presentToUnknownErrorAlertController as! T)
                }
                else if let step = T.self as? SignupStep.Type {
                    stepsHandler(SignupStep.presentToUnknownErrorAlertController as! T)
                }
                else if let step = T.self as? FindPwStep.Type {
                    stepsHandler(FindPwStep.presentToNetworkErrorAlertController as! T)
                }
            }
        } else {
            if let step = T.self as? AppStep.Type {
                stepsHandler(AppStep.presentToUnknownErrorAlertController as! T)
            }
            else if let step = T.self as? SignupStep.Type {
                stepsHandler(SignupStep.presentToUnknownErrorAlertController as! T)
            } 
            else if let step = T.self as? FindPwStep.Type {
                stepsHandler(FindPwStep.presentToNetworkErrorAlertController as! T)
            }
        }
    }
}
