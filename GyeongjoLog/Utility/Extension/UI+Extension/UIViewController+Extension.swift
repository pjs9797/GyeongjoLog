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
    
    func hideKeyboardExcludingButton(_ button: UIButton, disposeBag: DisposeBag) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [weak self] gesture in
            guard let self = self else { return }
            let location = gesture.location(in: self.view)
            
            // 버튼의 영역 안이 아닌 경우에만 키보드를 내립니다.
            if !button.frame.contains(location) {
                self.view.endEditing(true)
            }
        }.disposed(by: disposeBag)
    }
}

extension UIViewController {
    func bindKeyboardNotificationsForBottomButton(to button: UIButton, disposeBag: DisposeBag) {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak button] userInfo in
                if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                   let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    let keyboardHeight = keyboardFrame.height
                    let safeAreaBottom = self?.view.safeAreaInsets.bottom
                    
                    UIView.animate(withDuration: duration) {
                        button?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+(safeAreaBottom ?? 0))
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak button] userInfo in
                if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    UIView.animate(withDuration: duration) {
                        button?.transform = .identity
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
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
