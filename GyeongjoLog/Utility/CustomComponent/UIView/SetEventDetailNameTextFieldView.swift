import UIKit
import SnapKit

class SetEventDetailNameTextFieldView: UIView {
    var textFieldWidthConstraint: Constraint?
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Heading02
        textField.textColor = ColorManager.text01

        let placeholderText = "이름"
        var placeholderAttributes = AttributedFontManager.Heading02
        placeholderAttributes[.foregroundColor] = ColorManager.textDisabled ?? .gray
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    let pencilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_write
        return imageView
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_delete, for: .normal)
        return button
    }()
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.blue
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
        [clearButton,pencilImageView,nameTextField,clearButton,bottomBorderView]
            .forEach{
                addSubview($0)
            }
        
        clearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints { make in
            textFieldWidthConstraint = make.width.equalTo(42*ConstantsManager.standardWidth).constraint
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(nameTextField.snp.trailing).offset(1*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func textFieldDidChange(_ text: String) {
        let textWidth = text.size(withAttributes: [.font: nameTextField.font!]).width
        let totalWidth = textWidth + 52
        textFieldWidthConstraint?.update(offset: (textWidth+46)*ConstantsManager.standardWidth)
        self.snp.updateConstraints { make in
            make.width.equalTo(totalWidth*ConstantsManager.standardWidth)
        }
    }
    
    func updateWidthForEditing() {
        let text = nameTextField.text ?? ""
        let textWidth = text.size(withAttributes: [.font: nameTextField.font!]).width
        let totalWidth = textWidth + 52
        textFieldWidthConstraint?.update(offset: (textWidth+46)*ConstantsManager.standardWidth)
        self.snp.updateConstraints { make in
            make.width.equalTo(totalWidth*ConstantsManager.standardWidth)
        }
    }
    
    func updateWidthForNonEditing() {
        let text = nameTextField.text ?? ""
        let textWidth: CGFloat
        
        if text.size(withAttributes: [.font: nameTextField.font!]).width < "이름".size(withAttributes: [.font: nameTextField.font!]).width {
            textWidth = "이름".size(withAttributes: [.font: nameTextField.font!]).width
        }
        else {
            textWidth = text.size(withAttributes: [.font: nameTextField.font!]).width
        }
        
        let totalWidth = textWidth + 15
        textFieldWidthConstraint?.update(offset: textWidth + 4)
        self.snp.updateConstraints { make in
            make.width.equalTo(totalWidth * ConstantsManager.standardWidth)
        }
    }
}
