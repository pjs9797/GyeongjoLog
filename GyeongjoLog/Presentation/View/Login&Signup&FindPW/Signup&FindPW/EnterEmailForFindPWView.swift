import UIKit
import SnapKit

class EnterEmailForFindPWView: UIView {
    let findPWLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 잊으셨나요?"
        label.font = FontManager.Heading02
        label.textColor = ColorManager.text01
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 재설정하려는 이메일을 입력해주세요."
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text02
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
        [findPWLabel,descriptionLabel,emailTextFieldView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        findPWLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(findPWLabel.snp.bottom).offset(15*ConstantsManager.standardHeight)
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
