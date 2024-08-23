import UIKit
import SnapKit

class MyEventSummarySearchView: UIView {
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
    let innerShadowView: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 24*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    let innerShadowView2: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 24*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    let innerShadowView3: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 24*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    let innerShadowView4: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 24*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 24*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white?.withAlphaComponent(0.5)
        
        layoutShadow()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyBackgroundBlurEffect()
        innerShadowView.applyInnerShadow(color: ColorManager.white ?? .white, offset: CGSize(width: 1, height: 1), opacity: 0.16, radius: 4)
        innerShadowView2.applyInnerShadow(color: ColorManager.bgGray ?? .gray, offset: CGSize(width: -1, height: -1), opacity: 0.58, radius: 4)
        innerShadowView3.applyInnerShadow(color: ColorManager.bgGray ?? .gray, offset: CGSize(width: -1, height: -1), opacity: 0.34, radius: 4)
        innerShadowView4.applyInnerShadow(color: ColorManager.white ?? .white, offset: CGSize(width: 1, height: 1), opacity: 0.58, radius: 6)
        
        
//        innerShadowView.applyInnerShadow(color: ColorManager.red ?? .white, offset: CGSize(width: 10, height: 10), opacity: 1, radius: 4)
//        innerShadowView2.applyInnerShadow(color: ColorManager.orange ?? .gray, offset: CGSize(width: -10, height: -10), opacity: 1, radius: 4)
//        innerShadowView3.applyInnerShadow(color: ColorManager.green ?? .gray, offset: CGSize(width: -20, height: -20), opacity: 1, radius: 4)
//        innerShadowView4.applyInnerShadow(color: ColorManager.blue ?? .white, offset: CGSize(width: 20, height: 20), opacity: 1, radius: 6)
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
    
    private func layoutShadow(){
        addSubview(innerShadowView)
        addSubview(innerShadowView2)
        addSubview(innerShadowView3)
        addSubview(innerShadowView4)
        
        innerShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        innerShadowView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        innerShadowView3.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        innerShadowView4.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func applyBackgroundBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)

        blurEffectView.layer.cornerRadius = 24*ConstantsManager.standardHeight
        blurEffectView.clipsToBounds = true
    }
}
