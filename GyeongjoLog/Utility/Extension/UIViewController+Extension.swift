import UIKit
import RxSwift

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
    
    func bindKeyboardNotifications(to button: UIButton, disposeBag: DisposeBag) {
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
}
