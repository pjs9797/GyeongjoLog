import UIKit

class DimSheetPresentationController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sheet = self.sheetPresentationController {
            DispatchQueue.main.async {
                if let containerView = sheet.containerView {
                    if let dimmingView = containerView.subviews.first(where: { $0.isUserInteractionEnabled }) {
                        UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.38)
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let sheet = self.sheetPresentationController {
            if let containerView = sheet.containerView {
                if let dimmingView = containerView.subviews.first(where: { $0.isUserInteractionEnabled }) {
                    UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        dimmingView.backgroundColor = UIColor.clear
                    }, completion: nil)
                }
            }
        }
    }
}

