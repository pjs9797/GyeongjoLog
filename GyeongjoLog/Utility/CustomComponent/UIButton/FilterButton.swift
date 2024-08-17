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
        self.setTitle("필터", for: .normal)
        self.titleLabel?.font = FontManager.Body01
        self.setTitleColor(ColorManager.black, for: .normal)
        self.setTitleColor(ColorManager.black?.withAlphaComponent(0.6), for: .highlighted)
        self.setImage(ImageManager.icon_filter, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2*ConstantsManager.standardWidth, bottom: 0, right: -2*ConstantsManager.standardWidth)

    }
}
