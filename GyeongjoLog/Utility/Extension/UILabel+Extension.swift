import UIKit

extension UILabel {
    func updateText(_ text: String) {
        guard let currentAttributedText = self.attributedText else {
            self.text = text
            return
        }
        
        let attributes = currentAttributedText.attributes(at: 0, effectiveRange: nil)
        let newAttributedText = NSAttributedString(string: text, attributes: attributes)
        
        self.attributedText = newAttributedText
    }
}
