import UIKit

class ResetButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString("초기화")
        titleAttr.font = FontManager.Body01
        config.attributedTitle = titleAttr
        config.image = ImageManager.icon_reset
        config.imagePadding = 4*ConstantsManager.standardWidth
        config.baseForegroundColor = ColorManager.text03
        self.configuration = config
        
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
    }
}
