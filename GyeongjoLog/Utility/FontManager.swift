import UIKit

struct AttributedFontManager {
    static let Heading02 = pretendard(.bold, size: 24, lineHeight: 33.6, letterSpacing: -0.3)
    static let Heading01 = pretendard(.bold, size: 20, lineHeight: 28, letterSpacing: -0.3)
    
    static let SubHead03_Bold = pretendard(.bold, size: 18, lineHeight: 25.2, letterSpacing: -0.3)
    static let SubHead03_Medium = pretendard(.medium, size: 18, lineHeight: 25.2, letterSpacing: -0.3)
    
    static let SubHead02_Bold = pretendard(.bold, size: 16, lineHeight: 22.4, letterSpacing: -0.3)
    static let SubHead02_Medium = pretendard(.medium, size: 16, lineHeight: 22.4, letterSpacing: -0.3)
    
    static let SubHead01_Bold = pretendard(.bold, size: 14, lineHeight: 19.6, letterSpacing: -0.3)
    static let SubHead01_Medium = pretendard(.medium, size: 14, lineHeight: 19.6, letterSpacing: -0.3)
    
    static let SubTitle01 = pretendard(.bold, size: 12, lineHeight: 16.8, letterSpacing: -0.3)
    
    static let Body03 = pretendard(.regular, size: 18, lineHeight: 27, letterSpacing: -0.3)
    static let Body02 = pretendard(.regular, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let Body01 = pretendard(.regular, size: 14, lineHeight: 21, letterSpacing: -0.3)
    static let Caption = pretendard(.regular, size: 12, lineHeight: 16.8, letterSpacing: 0)
    
    static func pretendard(_ weight: UIFont.Weight, size: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat) -> NSAttributedString {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Pretendard-Bold"
        case .semibold:
            fontName = "Pretendard-SemiBold"
        case .medium:
            fontName = "Pretendard-Medium"
        case .regular:
            fontName = "Pretendard-Regular"
        default:
            fontName = "Pretendard-Regular"
        }
        
        let font = UIFont(name: fontName, size: size*ConstantsManager.standardWidth) ?? UIFont.systemFont(ofSize: size*ConstantsManager.standardWidth)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight*ConstantsManager.standardHeight
        paragraphStyle.maximumLineHeight = lineHeight*ConstantsManager.standardHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing*ConstantsManager.standardWidth,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: "text", attributes: attributes)
    }
}
