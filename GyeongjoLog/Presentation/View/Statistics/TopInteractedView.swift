import UIKit
import SnapKit

class TopInteractedView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        return label
    }()
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_right
        return imageView
    }()
    let clapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_clap
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.bgGray
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel,subTitleLabel,rightImageView,clapImageView]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(18*ConstantsManager.standardHeight)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(18*ConstantsManager.standardHeight)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*ConstantsManager.standardHeight)
            make.leading.equalTo(subTitleLabel.snp.trailing).offset(3*ConstantsManager.standardWidth)
            make.centerY.equalTo(subTitleLabel)
        }
        
        clapImageView.snp.makeConstraints { make in
            make.width.height.equalTo(65*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-38*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-18*ConstantsManager.standardHeight)
        }
    }
    
    func configureTopInteractedView(name: String?){
        if let name = name {
            rightImageView.isHidden = false
            let titleText = "이번달 \(name)님과 가장 많이 주고 받았어요"
            let attributedString = NSMutableAttributedString(string: titleText)
            
            attributedString.addAttribute(.font, value: FontManager.SubHead03_SemiBold, range: NSMakeRange(0, titleText.count))
            attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
            let range = (titleText as NSString).range(of: name)
            attributedString.addAttribute(.foregroundColor, value: ColorManager.blue ?? .blue, range: range)
            
            titleLabel.attributedText = attributedString
        }
        else {
            rightImageView.isHidden = true
            let titleText = "이번 달 아직 주고받은 사람이 없어요"
            let attributedString = NSMutableAttributedString(string: titleText)
            
            attributedString.addAttribute(.font, value: FontManager.SubHead03_SemiBold, range: NSMakeRange(0, titleText.count))
            attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
            
            titleLabel.attributedText = attributedString
        }
    }
    
    func configureCnt(cnt: Int) {
        subTitleLabel.text = "주고받은 횟수 \(cnt)회"
    }

}
