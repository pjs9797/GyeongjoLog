import UIKit
import SnapKit

class BeginingView: UIView {
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_letter
        return imageView
    }()
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.launchScreen
        return imageView
    }()
    let loginButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("로그인", for: .normal)
        button.isEnable()
        return button
    }()
    let signupButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("이메일로 회원가입", for: .normal)
        button.setTitleColor(ColorManager.text01, for: .normal)
        button.setTitleColor(ColorManager.text01?.withAlphaComponent(0.6), for: .highlighted)
        button.backgroundColor = ColorManager.white
        button.layer.borderColor = ColorManager.blueGray01?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let startNotLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하지 않고 시작하기", for: .normal)
        button.setTitleColor(ColorManager.text03, for: .normal)
        button.setTitleColor(ColorManager.text03?.withAlphaComponent(0.6), for: .highlighted)
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
        [firstImageView,secondImageView,loginButton,signupButton,startNotLoginButton]
            .forEach{
                addSubview($0)
            }
        
        firstImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(132*ConstantsManager.standardHeight)
        }
        
        secondImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstImageView.snp.bottom).offset(28*ConstantsManager.standardHeight)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(secondImageView.snp.bottom).offset(64*ConstantsManager.standardHeight)
        }
        
        signupButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(loginButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        startNotLoginButton.snp.makeConstraints { make in
            make.height.equalTo(20*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-22*ConstantsManager.standardHeight)
        }
    }
}
