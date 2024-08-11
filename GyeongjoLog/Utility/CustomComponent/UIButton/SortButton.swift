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
        config.title = "최신순"
        config.image = ImageManager.icon_dropdown
        config.imagePlacement = .trailing
        config.baseForegroundColor = ColorManager.black
        self.configuration = config
        self.titleLabel?.font = FontManager.Body01
    }
}
