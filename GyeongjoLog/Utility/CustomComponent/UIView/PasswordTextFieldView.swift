import UIKit
import SnapKit

class PasswordTextFieldView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        return label
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Body04
        textField.textColor = ColorManager.text01
        let placeholderText = "영문, 숫자, 특수문자 조합, 10글자 이상"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body04,
            .foregroundColor: ColorManager.textDisabled ?? .gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_BlueCheck
        imageView.isHidden = true
        return imageView
    }()
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "영문, 숫자, 특수문자 조합, 10글자 이상"
        label.font = FontManager.Body01
        label.textColor = ColorManager.red
        return label
    }()
    let showPasswordButton = ShowPasswordButton()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,passwordTextField,checkImageView,bottomBorderView,errorLabel,showPasswordButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(passwordTextField)
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(3*ConstantsManager.standardHeight)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(bottomBorderView.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        showPasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(bottomBorderView.snp.bottom).offset(18*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView(isEditing: Bool){
        titleLabel.textColor = isEditing ? ColorManager.blue : ColorManager.textDisabled
        bottomBorderView.backgroundColor = isEditing ? ColorManager.blue : ColorManager.lightGrayFrame
    }
}
