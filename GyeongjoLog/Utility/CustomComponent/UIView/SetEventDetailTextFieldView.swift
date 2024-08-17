import UIKit
import SnapKit

class SetEventDetailTextFieldView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text03
        return label
    }()
    let contentTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Body04
        textField.textColor = ColorManager.text01
        textField.keyboardType = .numberPad
        return textField
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_delete, for: .normal)
        button.isHidden = true
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
        [titleLabel,contentTextField,clearButton,bottomBorderView]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(268*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
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
        clearButton.isHidden = !isEditing
        bottomBorderView.backgroundColor = isEditing ? ColorManager.blue : ColorManager.lightGrayFrame
    }
}
