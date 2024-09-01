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
        let normalAttributes = [NSAttributedString.Key.foregroundColor: ColorManager.textDisabled ?? .gray, NSAttributedString.Key.font: FontManager.SubHead02_SemiBold]
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: ColorManager.black ?? .black, NSAttributedString.Key.backgroundColor: ColorManager.white ?? .white,  NSAttributedString.Key.font: FontManager.SubHead02_SemiBold]

        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
        
        selectedSegmentIndex = 0
        backgroundColor = ColorManager.bgGray
        layer.cornerRadius = 12 * ConstantsManager.standardHeight
        clipsToBounds = true
    }
}
