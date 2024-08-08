import UIKit

class FilterButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.icon_filter
        config.imagePadding = 2*ConstantsManager.standardWidth
        self.configuration = config
        
        let fontAttributes = AttributedFontManager.Body01
        let attributedTitle = NSAttributedString(string: "필터", attributes: fontAttributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
