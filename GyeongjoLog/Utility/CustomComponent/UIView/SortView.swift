import UIKit
import SnapKit

class SortView: UIView {
    let firstSortButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(ColorManager.blue, for: .normal)
        button.setTitleColor(ColorManager.blue?.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = FontManager.Body0201
        return button
    }()
    let secondSortButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(ColorManager.black, for: .normal)
        button.setTitleColor(ColorManager.black?.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = FontManager.Body0201
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4 * ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white?.withAlphaComponent(0.95)
        
        // 이펙트 추가
        //applyBackgroundBlurEffect()
//        applyDropShadows()
//        applyInnerShadows()
//        self.layer.applyDropShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 6, spread: 1)
//        self.layer.applyDropShadow(color: .black, alpha: 0.04, x: 0, y: 2, blur: 8, spread: 0)
//        self.layer.applyInnerShadow(color: ColorManager.bgGray!, alpha: 0.34, x: -1, y: -1, blur: 4, spread: 0)
//        self.layer.applyInnerShadow(color: ColorManager.white!, alpha: 0.58, x: 1, y: 1, blur: 6, spread: 0)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [firstSortButton, secondSortButton]
            .forEach{
                addSubview($0)
            }
        
        firstSortButton.snp.makeConstraints { make in
            make.width.equalTo(140 * ConstantsManager.standardWidth)
            make.height.equalTo(65 * ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        firstSortButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24 * ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(24 * ConstantsManager.standardHeight)
        }
        
        secondSortButton.snp.makeConstraints { make in
            make.width.equalTo(140 * ConstantsManager.standardWidth)
            make.height.equalTo(65 * ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(firstSortButton.snp.bottom)
        }
        
        secondSortButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24 * ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(24 * ConstantsManager.standardHeight)
        }
    }
    
    private func applyBackgroundBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.alpha = 0.5 // 이미지 1의 Blur 값 4를 반영하여 설정
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)
    }
    
    private func applyDropShadows() {
        // 이미지 2의 Drop Shadow
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 6
        self.layer.masksToBounds = false
        
        // 이미지 3의 Drop Shadow
        let additionalShadowLayer = CALayer()
        additionalShadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        additionalShadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        additionalShadowLayer.shadowRadius = 8
        additionalShadowLayer.frame = bounds
        layer.addSublayer(additionalShadowLayer)
    }
    
    private func applyInnerShadows() {
        // 이미지 4의 Inner Shadow
        let innerShadowLayer1 = CALayer()
        innerShadowLayer1.frame = bounds
        innerShadowLayer1.shadowColor = ColorManager.bgGray?.withAlphaComponent(0.34).cgColor
        innerShadowLayer1.shadowOffset = CGSize(width: -1, height: -1)
        innerShadowLayer1.shadowRadius = 4
        innerShadowLayer1.cornerRadius = 4 * ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer1)
        
        // 이미지 5의 Inner Shadow
        let innerShadowLayer2 = CALayer()
        innerShadowLayer2.frame = bounds
        innerShadowLayer2.shadowColor = UIColor.white.withAlphaComponent(0.58).cgColor
        innerShadowLayer2.shadowOffset = CGSize(width: 1, height: 1)
        innerShadowLayer2.shadowRadius = 6
        innerShadowLayer2.cornerRadius = 4 * ConstantsManager.standardHeight
        layer.addSublayer(innerShadowLayer2)
    }
    
    func setSortViewButton(title: String) {
        if title == "최신순" {
            self.firstSortButton.setTitleColor(ColorManager.blue, for: .normal)
            self.secondSortButton.setTitleColor(ColorManager.black, for: .normal)
        } else {
            self.firstSortButton.setTitleColor(ColorManager.black, for: .normal)
            self.secondSortButton.setTitleColor(ColorManager.blue, for: .normal)
        }
    }
}
