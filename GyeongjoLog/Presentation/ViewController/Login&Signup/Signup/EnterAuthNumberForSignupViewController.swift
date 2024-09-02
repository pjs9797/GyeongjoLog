import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterAuthNumberForSignupViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterAuthNumberForSignupView = EnterAuthNumberForSignupView()
    
    init(with reactor: EnterAuthNumberForSignupReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterAuthNumberForSignupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterAuthNumberForSignupView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterAuthNumberForSignupView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "회원가입"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterAuthNumberForSignupViewController {
    func bind(reactor: EnterAuthNumberForSignupReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterAuthNumberForSignupReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterAuthNumberForSignupView.authNumberTextFieldView.authNumberTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.authNumberTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberForSignupView.authNumberTextFieldView.authNumberTextField.rx.text.orEmpty
            .map { Reactor.Action.inputAuthNumberText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberForSignupView.authNumberTextFieldView.reSendButton.rx.tap
            .map{ Reactor.Action.reSendButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberForSignupView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterAuthNumberForSignupReactor){
        reactor.state.map{ $0.isEditingAuthNumberTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterAuthNumberForSignupView.authNumberTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.remainingSeconds }
            .distinctUntilChanged()
            .map { seconds -> String in
                let minutes = seconds / 60
                let seconds = seconds % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .bind(to: enterAuthNumberForSignupView.authNumberTextFieldView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterAuthNumberForSignupView.nextButton.isEnable()
                }
                else {
                    self?.enterAuthNumberForSignupView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
