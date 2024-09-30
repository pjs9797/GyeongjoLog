import UIKit
import SnapKit
import RxFlow


class LaunchScreenViewController: UIViewController {
    let window: UIWindow
    let coordinator: FlowCoordinator
    let appFlow: AppFlow
    let launchScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.launchScreen
        return imageView
    }()
    
    init(window: UIWindow, coordinator: FlowCoordinator , appFlow: AppFlow) {
        self.window = window
        self.coordinator = coordinator
        self.appFlow = appFlow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorManager.white
        layout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            Flows.use(self?.appFlow ?? AppFlow(), when: .created) { root in
                self?.window.rootViewController = root
                self?.window.makeKeyAndVisible()
            }
            if UserDefaultsManager.shared.getOnBoardingStarted() {
                if UserDefaultsManager.shared.isLoggedIn() {
                    self?.coordinator.coordinate(flow: self?.appFlow ?? AppFlow(), with: OneStepper(withSingleStep: AppStep.navigateToTabBarController))
                }
                else {
                    self?.coordinator.coordinate(flow: self?.appFlow ?? AppFlow(), with: OneStepper(withSingleStep: AppStep.navigateToBeginingViewController))
                }
            }
            else {
                self?.coordinator.coordinate(flow: self?.appFlow ?? AppFlow(), with: OneStepper(withSingleStep: AppStep.navigateToOnBoardingViewController))
            }
        }
    }
    
    private func layout() {
        view.addSubview(launchScreenImageView)
        
        launchScreenImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
