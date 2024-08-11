import UIKit
import SnapKit

class SetEventDetailButtonView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text03
        return label
    }()
    let contentButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = FontManager.Body04
        button.setTitleColor(ColorManager.text01, for: .normal)
        return button
    }()
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
        
    init(frame: CGRect, titleText: String) {
        super.init(frame: frame)
        
        titleLabel.text = titleText
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,contentButton,bottomBorderView]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentButton.snp.makeConstraints { make in
            make.width.equalTo(268*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.width.equalTo(268*ConstantsManager.standardWidth)
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView(isEditing: Bool){
        bottomBorderView.backgroundColor = isEditing ? ColorManager.blue : ColorManager.lightGrayFrame
    }
}
