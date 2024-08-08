import UIKit

struct FontManager {
    static let Heading02 = pretendard(.semibold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading01 = pretendard(.semibold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead03_SemiBold = pretendard(.semibold, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_Medium = pretendard(.medium, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead02_SemiBold = pretendard(.semibold, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_Medium = pretendard(.medium, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead01_SemiBold = pretendard(.semibold, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_Medium = pretendard(.medium, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubTitle01 = pretendard(.semibold, size: 12, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let Body03 = pretendard(.medium, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body02 = pretendard(.medium, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body01 = pretendard(.medium, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Caption = pretendard(.medium, size: 12, lineHeightPercentage: 140, letterSpacing: 0)
    
    static func pretendard(_ weight: UIFont.Weight, size: CGFloat, lineHeightPercentage: CGFloat, letterSpacing: CGFloat) -> NSAttributedString {
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
        let actualLineHeight = size * lineHeightPercentage / 100
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = actualLineHeight*ConstantsManager.standardHeight
        paragraphStyle.maximumLineHeight = actualLineHeight*ConstantsManager.standardHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing*ConstantsManager.standardWidth,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: "text", attributes: attributes)
    }
}

struct AttributedFontManager {
    static let Heading02 = attributes(.semibold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading01 = attributes(.semibold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead03_SemiBold = attributes(.semibold, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_Medium = attributes(.medium, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead02_SemiBold = attributes(.semibold, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_Medium = attributes(.medium, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubHead01_SemiBold = attributes(.semibold, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_Medium = attributes(.medium, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let SubTitle01 = attributes(.semibold, size: 12, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    static let Body03 = attributes(.medium, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body02 = attributes(.medium, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body01 = attributes(.medium, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Caption = attributes(.medium, size: 12, lineHeightPercentage: 140, letterSpacing: 0)

    static func attributes(_ weight: UIFont.Weight, size: CGFloat, lineHeightPercentage: CGFloat, letterSpacing: CGFloat) -> [NSAttributedString.Key: Any] {
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
        
        let font = UIFont(name: fontName, size: size * ConstantsManager.standardWidth) ?? UIFont.systemFont(ofSize: size * ConstantsManager.standardWidth)
        let actualLineHeight = size * lineHeightPercentage / 100
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = actualLineHeight * ConstantsManager.standardHeight
        paragraphStyle.maximumLineHeight = actualLineHeight * ConstantsManager.standardHeight
        
        return [
            .font: font,
            .kern: letterSpacing * ConstantsManager.standardWidth,
            .paragraphStyle: paragraphStyle
        ]
    }
}
