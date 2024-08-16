import UIKit

class FilterButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString("필터")
        titleAttr.font = FontManager.Body01
        config.attributedTitle = titleAttr
        config.title = "필터"
        config.image = ImageManager.icon_filter
        config.imagePadding = 2*ConstantsManager.standardWidth
        config.baseForegroundColor = ColorManager.black
        
        self.configuration = config
//        self.setTitleColor(ColorManager.black, for: .normal)
//        self.setTitleColor(ColorManager.black?.withAlphaComponent(0.8), for: .highlighted)
    }
    
//    private func configureButton() {
//        // 타이틀 설정
//        var config = UIButton.Configuration.plain()
////        var titleAttr = AttributedString("필터")
////        titleAttr.font = FontManager.Body01
////        config.attributedTitle = titleAttr
//        config.imagePadding = 2*ConstantsManager.standardWidth
//        self.configuration = config
//        
//        self.setTitle("필터", for: .normal)
//        self.setTitleColor(ColorManager.black, for: .normal)
//        self.setTitleColor(ColorManager.black?.withAlphaComponent(0.8), for: .highlighted)
//        
//        // 폰트 설정
//        self.titleLabel?.font = FontManager.Body01
//        
//        // 이미지 설정
//        self.setImage(ImageManager.icon_filter, for: .normal)
//        
//        // 이미지와 타이틀 간격 설정 (titleEdgeInsets만 사용)
//        //self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2 * ConstantsManager.standardWidth, bottom: 0, right: 0)
//        
//        // 버튼의 기본 속성 설정
//        self.tintColor = ColorManager.black
//        self.contentHorizontalAlignment = .left
//    }
}
