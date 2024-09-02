import UIKit
import SnapKit

class LoginView: UIView {
    let emailTextFieldView = EmailTextFieldView()
    let passwordTextFieldView: PasswordTextFieldView = {
        let view = PasswordTextFieldView()
        view.titleLabel.text = "비밀번호"
        view.errorLabel.isHidden = true
        return view
    }()
    let loginButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("로그인", for: .normal)
        button.isEnable()
        return button
    }()
    let findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        button.setTitleColor(ColorManager.textDisabled, for: .normal)
        button.setTitleColor(ColorManager.textDisabled?.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = FontManager.Body01
        button.setUnderline()
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
        [emailTextFieldView,passwordTextFieldView,loginButton,findPasswordButton]
            .forEach{
                addSubview($0)
            }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(42*ConstantsManager.standardHeight)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
    }
}
