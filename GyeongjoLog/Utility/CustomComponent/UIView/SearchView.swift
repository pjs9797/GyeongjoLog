import UIKit
import SnapKit

class SearchView: UIView {
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_search
        return imageView
    }()
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.SubHead02_Medium
        textField.textColor = ColorManager.text01
        
        let placeholderText = "이름 및 전화번호로 검색하세요."
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.SubHead02_Medium,
            .foregroundColor: ColorManager.text02 ?? .gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 24*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [searchImageView, searchTextField]
            .forEach{
                addSubview($0)
            }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(24*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview().offset(-1*ConstantsManager.standardHeight)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(14*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-24*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    // Blur 이펙트를 적용하는 함수
    func applyBackgroundBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.alpha = 0.8
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)
    }
    
    // Inner Shadow를 적용하는 함수
    func applyInnerShadows() {
        let innerShadowLayer1 = CALayer()
        innerShadowLayer1.frame = bounds
        innerShadowLayer1.shadowColor = UIColor.white.withAlphaComponent(0.16).cgColor
        innerShadowLayer1.shadowOffset = CGSize(width: 1, height: 1)
        innerShadowLayer1.shadowRadius = 6
        innerShadowLayer1.cornerRadius = 24*ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer1)

        let innerShadowLayer2 = CALayer()
        innerShadowLayer2.frame = bounds
        innerShadowLayer2.shadowColor = ColorManager.bgGray?.withAlphaComponent(0.34).cgColor
        innerShadowLayer2.shadowOffset = CGSize(width: -1, height: -1)
        innerShadowLayer2.shadowRadius = 4
        innerShadowLayer2.cornerRadius = 24*ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer2)
        
        let innerShadowLayer3 = CALayer()
        innerShadowLayer3.frame = bounds
        innerShadowLayer3.shadowColor = ColorManager.bgGray?.withAlphaComponent(0.34).cgColor
        innerShadowLayer3.shadowOffset = CGSize(width: -1, height: -1)
        innerShadowLayer3.shadowRadius = 4
        innerShadowLayer3.cornerRadius = 24*ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer3)

        // 이미지 5에 해당하는 Inner Shadow
        let innerShadowLayer4 = CALayer()
        innerShadowLayer4.frame = bounds
        innerShadowLayer4.shadowColor = UIColor.white.withAlphaComponent(0.58).cgColor
        innerShadowLayer4.shadowOffset = CGSize(width: 1, height: 1)
        innerShadowLayer4.shadowRadius = 4
        innerShadowLayer4.cornerRadius = 24*ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer4)
    }
}
