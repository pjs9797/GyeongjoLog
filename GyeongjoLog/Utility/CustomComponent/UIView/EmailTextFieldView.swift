import UIKit
import SnapKit

class EmailTextFieldView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = FontManager.Body0201
        return label
    }()
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Body04
        textField.textColor = ColorManager.text01
        textField.keyboardType = .emailAddress
        let placeholderText = "gyeongjolog@log.com"
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
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,emailTextField,checkImageView,bottomBorderView]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(emailTextField)
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(3*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView(isEditing: Bool){
        titleLabel.textColor = isEditing ? ColorManager.blue : ColorManager.textDisabled
        bottomBorderView.backgroundColor = isEditing ? ColorManager.blue : ColorManager.lightGrayFrame
    }
}
