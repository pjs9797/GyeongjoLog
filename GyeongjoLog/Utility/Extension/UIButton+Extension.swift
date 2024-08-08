import UIKit

extension UIButton {
    func updateTitle(_ title: String) {
        guard let currentAttributedTitle = self.attributedTitle(for: .normal) else {
            self.setTitle(title, for: .normal)
            return
        }
        
        let attributes = currentAttributedTitle.attributes(at: 0, effectiveRange: nil)
        let newAttributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        self.setAttributedTitle(newAttributedTitle, for: .normal)
    }
}
