import UIKit

class InnerShadowView: UIView {
    let shadowLayer = CALayer()
    
    func applyInnerShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        shadowLayer.frame = bounds

        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        
        let path = UIBezierPath(rect: bounds.insetBy(dx: -radius, dy: -radius))
        let innerPath = UIBezierPath(rect: bounds).reversing()
        path.append(innerPath)
        
        shadowLayer.shadowPath = path.cgPath

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: bounds).cgPath
        shadowLayer.mask = maskLayer

        layer.addSublayer(shadowLayer)
    }
}
