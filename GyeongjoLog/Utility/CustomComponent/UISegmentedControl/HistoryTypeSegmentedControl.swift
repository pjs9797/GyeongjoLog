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
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.SubHead02_SemiBold,
            .foregroundColor: ColorManager.textDisabled!
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.SubHead02_SemiBold,
            .foregroundColor: ColorManager.black!,
            .backgroundColor: ColorManager.white!
        ]
        
        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
        
        selectedSegmentIndex = 0
        backgroundColor = ColorManager.bgGray
        layer.cornerRadius = 12 * ConstantsManager.standardHeight
        clipsToBounds = true
    }
}
