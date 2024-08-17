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
        self.setTitle("최신순", for: .normal)
        self.titleLabel?.font = FontManager.Body01
        self.setTitleColor(ColorManager.black, for: .normal)
        self.setTitleColor(ColorManager.black?.withAlphaComponent(0.6), for: .highlighted)
        self.setImage(ImageManager.icon_dropdown, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
    }
}
