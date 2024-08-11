import UIKit

class BottomButton: UIButton {
    var config = UIButton.Configuration.plain()
    
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        self.backgroundColor = ColorManager.lightGray01
        self.layer.cornerRadius = 8*ConstantsManager.standardHeight
    }
    
    func setButtonTitle(_ title: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = FontManager.Body03
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        config.baseForegroundColor = ColorManager.white
        self.configuration = config
    }
    
    func isNotEnable(){
        self.backgroundColor = ColorManager.lightGray01
        self.isEnabled = false
    }
    
    func isEnable(){
        self.backgroundColor = ColorManager.blue
        self.isEnabled = true
    }
}
