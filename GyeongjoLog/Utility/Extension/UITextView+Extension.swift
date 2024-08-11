import UIKit

extension UITextView {
    func addPadding(width: CGFloat, height: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.addSubview(paddingView)
        self.textContainer.lineFragmentPadding = width
        self.textContainerInset.top = height
    }
}
