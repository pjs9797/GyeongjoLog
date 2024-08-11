import UIKit

class HistoryTypeSegmentedControl: UISegmentedControl {
    init(items: [String] = ["나의 경조사", "타인 경조사"]) {
        super.init(items: items)
        configureSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSegmentedControl() {
        var normalAttributes = AttributedFontManager.SubHead02_SemiBold
        normalAttributes[.foregroundColor] = ColorManager.textDisabled ?? .gray
        var selectedAttributes = AttributedFontManager.SubHead02_SemiBold
        selectedAttributes[.foregroundColor] = ColorManager.black ?? .black
        selectedAttributes[.backgroundColor] = ColorManager.white ?? .white
        
        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
        
        selectedSegmentIndex = 0
        backgroundColor = ColorManager.bgGray
        layer.cornerRadius = 12 * ConstantsManager.standardHeight
        clipsToBounds = true
    }
}
