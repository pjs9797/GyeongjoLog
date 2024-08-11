import UIKit

struct FontManager {
    //Heading
    static let Heading03 = pretendard(.bold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading02 = pretendard(.semibold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading0101 = pretendard(.bold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading01 = pretendard(.semibold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //SubHead
    static let SubHead04_SemiBold = pretendard(.semibold, size: 22, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_SemiBold = pretendard(.semibold, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_Medium = pretendard(.medium, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_SemiBold = pretendard(.semibold, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_Medium = pretendard(.medium, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_SemiBold = pretendard(.semibold, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_Medium = pretendard(.medium, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //SubTitle
    static let SubTitle01 = pretendard(.semibold, size: 12, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //Body
    static let Body04 = pretendard(.medium, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body03 = pretendard(.semibold, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body0201 = pretendard(.medium, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body02 = pretendard(.semibold, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body0101 = pretendard(.semibold, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body01 = pretendard(.medium, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    
    //Caption
    static let Caption = pretendard(.medium, size: 12, lineHeightPercentage: 140, letterSpacing: 0)
    static let Caption02 = pretendard(.bold, size: 12, lineHeightPercentage: 140, letterSpacing: 0)
    static let Caption01 = pretendard(.medium, size: 13, lineHeightPercentage: 140, letterSpacing: 0)
    
    static func pretendard(_ weight: UIFont.Weight, size: CGFloat, lineHeightPercentage: CGFloat, letterSpacing: CGFloat) -> UIFont {
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

        return font
    }
}

struct AttributedFontManager {
    //Heading
    static let Heading03 = attributes(.bold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading02 = attributes(.semibold, size: 24, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading0101 = attributes(.bold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let Heading01 = attributes(.semibold, size: 20, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //SubHead
    static let SubHead04_SemiBold = attributes(.semibold, size: 22, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_SemiBold = attributes(.semibold, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead03_Medium = attributes(.medium, size: 18, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_SemiBold = attributes(.semibold, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead02_Medium = attributes(.medium, size: 16, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_SemiBold = attributes(.semibold, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    static let SubHead01_Medium = attributes(.medium, size: 14, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //SubTitle
    static let SubTitle01 = attributes(.semibold, size: 12, lineHeightPercentage: 140, letterSpacing: -0.3)
    
    //Body
    static let Body04 = attributes(.medium, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body03 = attributes(.semibold, size: 18, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body0201 = attributes(.medium, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body02 = attributes(.semibold, size: 16, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body0101 = attributes(.semibold, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    static let Body01 = attributes(.medium, size: 14, lineHeightPercentage: 150, letterSpacing: -0.3)
    
    //Caption
    static let Caption = attributes(.medium, size: 12, lineHeightPercentage: 140, letterSpacing: 0)
    static let Caption02 = attributes(.bold, size: 12, lineHeightPercentage: 140, letterSpacing: 0)
    static let Caption01 = attributes(.medium, size: 13, lineHeightPercentage: 140, letterSpacing: 0)

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
        let baselineOffset = (actualLineHeight - font.lineHeight) / 2
        paragraphStyle.minimumLineHeight = actualLineHeight
        paragraphStyle.maximumLineHeight = actualLineHeight
        paragraphStyle.lineHeightMultiple = 1.0
        
        return [
            .font: font,
            .kern: letterSpacing * ConstantsManager.standardWidth,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset
        ]
    }
}
