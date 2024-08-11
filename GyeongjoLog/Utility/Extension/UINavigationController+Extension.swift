import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
        navigationBar.titleTextAttributes = [
            .font: FontManager.Heading01,
            .foregroundColor: ColorManager.text01 ?? .black
        ]
        navigationBar.tintColor = ColorManager.black
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
