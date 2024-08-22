import UIKit
import RxSwift
import RxKeyboard
import SnapKit

extension UIViewController: UIGestureRecognizerDelegate{
    func hideKeyboard(disposeBag: DisposeBag) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    
}

extension UIViewController {
    
    func bindKeyboardNotifications(to scrollView: UIScrollView, button: UIButton, textView: UITextView, in view: UIView, disposeBag: DisposeBag) {
        // 키보드 높이에 반응하는 observable
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                
                let safeAreaBottomInset = view.safeAreaInsets.bottom
                let adjustedHeight = keyboardHeight - safeAreaBottomInset
                
                if keyboardHeight > 0 {
                    // 키보드가 올라올 때
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: adjustedHeight, right: 0)
                    scrollView.scrollIndicatorInsets = scrollView.contentInset
                    
                    if textView.isFirstResponder {
                        // 텍스트뷰와 추가 버튼이 모두 보이도록 스크롤
                        let addButtonRect = button.convert(button.bounds, to: scrollView)
                        let adjustedRect = addButtonRect.insetBy(dx: 0, dy: -25)
                        scrollView.scrollRectToVisible(adjustedRect, animated: true)
                    }
                } else {
                    // 키보드가 내려갈 때
                    scrollView.contentInset = .zero
                    scrollView.scrollIndicatorInsets = .zero
                }
                
            })
            .disposed(by: disposeBag)
        
    }
}
