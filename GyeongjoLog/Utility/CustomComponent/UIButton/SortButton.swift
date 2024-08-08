import UIKit

class SortButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.icon_dropdown
        config.imagePlacement = .trailing
        self.configuration = config
        
        let fontAttributes = AttributedFontManager.Body01
        let attributedTitle = NSAttributedString(string: "최신순", attributes: fontAttributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
