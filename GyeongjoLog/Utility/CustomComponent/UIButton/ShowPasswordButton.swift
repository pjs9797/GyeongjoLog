import UIKit

class ShowPasswordButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        self.setImage(ImageManager.icon_RoundCehck20, for: .normal)
        self.setTitle("비밀번호 표시", for: .normal)
        self.titleLabel?.font = FontManager.Body01
        self.setTitleColor(ColorManager.text03, for: .normal)
        self.setTitleColor(ColorManager.text03?.withAlphaComponent(0.6), for: .highlighted)
        self.setImage(ImageManager.icon_filter, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4*ConstantsManager.standardWidth, bottom: 0, right: -4*ConstantsManager.standardWidth)
    }
}
