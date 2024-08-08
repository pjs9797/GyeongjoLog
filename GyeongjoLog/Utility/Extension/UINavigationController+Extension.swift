import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
        let attributes = [ NSAttributedString.Key.font: FontManager.Heading01 ]

        navigationBar.titleTextAttributes = attributes
        navigationBar.tintColor = ColorManager.text01
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
