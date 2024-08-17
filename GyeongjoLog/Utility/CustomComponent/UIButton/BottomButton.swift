import UIKit

class BottomButton: UIButton {
    
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
        self.titleLabel?.font = FontManager.Body03
        self.setTitleColor(ColorManager.white, for: .normal)
        self.setTitleColor(ColorManager.white?.withAlphaComponent(0.6), for: .highlighted)
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
