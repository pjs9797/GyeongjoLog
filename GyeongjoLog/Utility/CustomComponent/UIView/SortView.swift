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
    let firstDropShadowView: DropShadowView = {
        let dropShadowView = DropShadowView()
        dropShadowView.layer.cornerRadius = 4*ConstantsManager.standardHeight
        dropShadowView.backgroundColor = ColorManager.white?.withAlphaComponent(0.95)
        return dropShadowView
    }()
    let secondDropShadowView: DropShadowView = {
        let dropShadowView = DropShadowView()
        dropShadowView.layer.cornerRadius = 4*ConstantsManager.standardHeight
        dropShadowView.backgroundColor = ColorManager.white?.withAlphaComponent(0.95)
        return dropShadowView
    }()
    let innerShadowView: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 4*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    let innerShadowView2: InnerShadowView = {
        let innerShadowView = InnerShadowView()
        innerShadowView.shadowLayer.cornerRadius = 4*ConstantsManager.standardHeight
        innerShadowView.shadowLayer.masksToBounds = true
        return innerShadowView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white?.withAlphaComponent(0.95)
        
        layoutShadow()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyBackgroundBlurEffect()
        firstDropShadowView.setupShadow(color: ColorManager.black ?? .black, offset: CGSize(width: 0, height: 4), opacity: 0.04, radius: 6)
        secondDropShadowView.setupShadow(color: ColorManager.black ?? .black, offset: CGSize(width: 0, height: 2), opacity: 0.04, radius: 8)
        
        innerShadowView.applyInnerShadow(color: ColorManager.bgGray ?? .gray, offset: CGSize(width: -1, height: -1), opacity: 0.34, radius: 4)
        innerShadowView2.applyInnerShadow(color: ColorManager.white ?? .white, offset: CGSize(width: 1, height: 1), opacity: 0.58, radius: 6)
        
//        firstDropShadowView.setupShadow(color: ColorManager.red ?? .black, offset: CGSize(width: 0, height: 40), opacity: 1, radius: 6)
//        secondDropShadowView.setupShadow(color: ColorManager.green ?? .black, offset: CGSize(width: 0, height: 20), opacity: 1, radius: 8)
//
//        innerShadowView.applyInnerShadow(color: ColorManager.red ?? .gray, offset: CGSize(width: -10, height: -10), opacity: 1, radius: 4)
//        innerShadowView2.applyInnerShadow(color: ColorManager.green ?? .white, offset: CGSize(width: 10, height: 10), opacity: 1, radius: 6)
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
    
    private func layoutShadow(){
        addSubview(firstDropShadowView)
        addSubview(secondDropShadowView)
        addSubview(innerShadowView)
        addSubview(innerShadowView2)
        
        firstDropShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondDropShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        innerShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        innerShadowView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func applyBackgroundBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        blurEffectView.layer.cornerRadius = 4*ConstantsManager.standardHeight
        blurEffectView.clipsToBounds = true
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

