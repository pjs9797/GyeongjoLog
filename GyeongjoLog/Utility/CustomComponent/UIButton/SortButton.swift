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
        var titleAttr = AttributedString("최신순")
        titleAttr.font = FontManager.Body01
        config.attributedTitle = titleAttr
        config.image = ImageManager.icon_dropdown
        config.imagePlacement = .trailing
        config.baseForegroundColor = ColorManager.black
        self.configuration = config
    }
}
