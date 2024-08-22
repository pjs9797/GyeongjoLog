import UIKit

extension CALayer {
    // 보더 추가
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    
    func applyDropShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func applyInnerShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        // 이너 쉐도우 레이어를 생성
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = backgroundColor // 원래 배경색 유지
        
        // 그림자 설정
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = alpha
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowRadius = blur / UIScreen.main.scale
        
        // 스프레드 적용
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        let largerRect = CGRect(x: rect.origin.x - blur, y: rect.origin.y - blur, width: rect.width + 2 * blur, height: rect.height + 2 * blur)
        shadowLayer.shadowPath = UIBezierPath(rect: largerRect).cgPath
        
        // 마스크 생성 (이너 쉐도우 효과를 위해 내부를 잘라내기)
        let innerPath = UIBezierPath(rect: bounds).cgPath
        let cutout = CGMutablePath()
        cutout.addRect(largerRect)
        cutout.addPath(innerPath)
        let maskLayer = CAShapeLayer()
        maskLayer.path = cutout
        maskLayer.fillRule = .evenOdd
        
        shadowLayer.mask = maskLayer
        addSublayer(shadowLayer)
    }
}
