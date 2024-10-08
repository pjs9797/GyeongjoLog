import UIKit
import RxFlow
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var appFlow: AppFlow!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appFlow = AppFlow()
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        let launchScreenViewController = LaunchScreenViewController(window: window!, coordinator: coordinator, appFlow: appFlow)
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
//        Flows.use(appFlow, when: .created) { [unowned self] root in
//            self.window?.rootViewController = root
//            self.window?.makeKeyAndVisible()
//        }
//        
//        coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToTabBarController))
//        
//        if UserDefaultsManager.shared.getOnBoardingStarted() {
//            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToTabBarController))
//        }
//        else {
//            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToOnBoardingViewController))
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

