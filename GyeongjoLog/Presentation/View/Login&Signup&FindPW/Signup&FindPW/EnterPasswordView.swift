import UIKit
import SnapKit

class EnterPasswordView: UIView {
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 입력"
        label.font = FontManager.Heading02
        label.textColor = ColorManager.text01
        return label
    }()
    let passwordTextFieldView: PasswordTextFieldView = {
        let view = PasswordTextFieldView()
        view.titleLabel.text = "비밀번호"
        return view
    }()
    let rePasswordTextFieldView: PasswordTextFieldView = {
        let view = PasswordTextFieldView()
        view.titleLabel.text = "비밀번호 확인"
        view.errorLabel.text = "비밀번호 불일치"
        return view
    }()
    let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("회원가입", for: .normal)
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
        [passwordLabel,passwordTextFieldView,rePasswordTextFieldView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(passwordLabel.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        rePasswordTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(42*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
