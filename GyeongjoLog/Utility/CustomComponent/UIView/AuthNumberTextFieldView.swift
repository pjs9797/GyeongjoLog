import UIKit
import SnapKit

class AuthNumberTextFieldView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        return label
    }()
    let authNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Body04
        textField.textColor = ColorManager.text01
        textField.keyboardType = .numberPad
        let placeholderText = "번호 6자리 입력"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body04,
            .foregroundColor: ColorManager.textDisabled ?? .gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.blue
        return label
    }()
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let text = "메일을 받지 못했다면 인증 번호 재전송 요청하거나 스팸 메일함을\n확인해 보세요"
        var attribute = AttributedFontManager.Caption01
        attribute[.foregroundColor] = ColorManager.textDisabled ?? .gray
        label.attributedText = NSAttributedString(string: text, attributes: attribute)
        return label
    }()
    let reSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증 번호 재전송", for: .normal)
        button.setTitleColor(ColorManager.text02, for: .normal)
        button.setTitleColor(ColorManager.text02?.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = FontManager.Body01
        button.setUnderline()
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,authNumberTextField,timerLabel,bottomBorderView,descriptionLabel,reSendButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        authNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(authNumberTextField)
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(authNumberTextField.snp.bottom).offset(3*ConstantsManager.standardHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(bottomBorderView.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        reSendButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView(isEditing: Bool){
        titleLabel.textColor = isEditing ? ColorManager.blue : ColorManager.textDisabled
        bottomBorderView.backgroundColor = isEditing ? ColorManager.blue : ColorManager.lightGrayFrame
    }
}
