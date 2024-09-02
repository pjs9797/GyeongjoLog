import UIKit
import SnapKit

class EnterEmailForSignupView: UIView {
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 입력"
        label.font = FontManager.Heading02
        label.textColor = ColorManager.text01
        return label
    }()
    let emailTextFieldView = EmailTextFieldView()
    let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("이메일 인증 요청", for: .normal)
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
        [emailLabel,emailTextFieldView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
