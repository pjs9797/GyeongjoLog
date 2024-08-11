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
        config.title = "필터"
        config.image = ImageManager.icon_filter
        config.imagePadding = 2*ConstantsManager.standardWidth
        config.baseForegroundColor = ColorManager.black
        self.configuration = config
        self.titleLabel?.font = FontManager.Body01
    }
}
