import UIKit
import SnapKit

class EnterAuthNumberForSignupView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 계정 인증"
        label.font = FontManager.Heading02
        label.textColor = ColorManager.text01
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "userEmail")
        label.font = FontManager.Body04
        label.textColor = ColorManager.blue
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let text = "계정 인증을 위해 위 메일로 보내드린 인증 번호를\n입력해 주세요"
        var attribute = AttributedFontManager.Body0201
        attribute[.foregroundColor] = ColorManager.text01 ?? .black
        label.attributedText = NSAttributedString(string: text, attributes: attribute)
        return label
    }()
    let authNumberTextFieldView = AuthNumberTextFieldView()
    let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("이메일 인증 완료", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = ColorManager.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,emailLabel,descriptionLabel,authNumberTextFieldView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        authNumberTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(26*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
