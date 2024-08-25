import UIKit
import SnapKit

class InquiryView: UIView {
    let inquiryTitleLabel: UILabel = {
        let label = UILabel()
        let text = "안녕하세요 경조로그입니다 :)"
        var attribute = AttributedFontManager.SubHead02_SemiBold
        attribute[.foregroundColor] = ColorManager.black ?? .black
        label.attributedText = NSAttributedString(string: text, attributes: attribute)
        return label
    }()
    let inquiryContentLabel: UILabel = {
        let label = UILabel()
        let text = "저희 경조로그는 여러분의 경조사 기록 및 관리를 더욱 편리하게 만들어 드리기 위해 노력하고 있습니다. 사용 중 불편한 점이나 궁금한 점이 있으시다면 언제든지 편하게 문의해 주세요.\n여러분의 소중한 의견으로 더 나은 경조로그가 되겠습니다!"
        var attribute = AttributedFontManager.Body01
        attribute[.foregroundColor] = ColorManager.text03 ?? .gray
        label.attributedText = NSAttributedString(string: text, attributes: attribute)
        label.numberOfLines = 0
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일: "
        label.font = FontManager.Body01
        label.textColor = ColorManager.text03
        return label
    }()
    let sendEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("1997pjs@naver.com", for: .normal)
        button.setTitleColor(ColorManager.blue, for: .normal)
        button.setTitleColor(ColorManager.blue?.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = FontManager.Body01
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
        [inquiryTitleLabel,inquiryContentLabel,emailLabel,sendEmailButton]
            .forEach{
                addSubview($0)
            }
        
        inquiryTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        inquiryContentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(inquiryTitleLabel.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.top.equalTo(inquiryContentLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        sendEmailButton.snp.makeConstraints { make in
            make.leading.equalTo(emailLabel.snp.trailing)
            make.centerY.equalTo(emailLabel)
        }
    }
}
