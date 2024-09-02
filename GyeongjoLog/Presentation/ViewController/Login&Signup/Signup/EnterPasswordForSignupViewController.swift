import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterPasswordForSignupViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterPasswordForSignupView = EnterPasswordForSignupView()
    
    init(with reactor: EnterPasswordForSignupReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterPasswordForSignupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterPasswordForSignupView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterPasswordForSignupView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "회원가입"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterPasswordForSignupViewController {
    func bind(reactor: EnterPasswordForSignupReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterPasswordForSignupReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterPasswordForSignupView.passwordTextFieldView.passwordTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.passwordTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.passwordTextFieldView.passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.inputPasswordText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.passwordTextFieldView.showPasswordButton.rx.tap
            .map{ Reactor.Action.showPasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.rePasswordTextFieldView.passwordTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.rePasswordTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.rePasswordTextFieldView.passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.inputRePasswordText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.rePasswordTextFieldView.showPasswordButton.rx.tap
            .map{ Reactor.Action.showRePasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordForSignupView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterPasswordForSignupReactor){
        reactor.state.map{ $0.isEditingPasswordTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterPasswordForSignupView.passwordTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEditingRePasswordTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterPasswordForSignupView.rePasswordTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isSecurePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.enterPasswordForSignupView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_RoundCehck20, for: .normal)
                    self?.enterPasswordForSignupView.passwordTextFieldView.passwordTextField.isSecureTextEntry = true
                }
                else {
                    self?.enterPasswordForSignupView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_BlueRoundCheck20, for: .normal)
                    self?.enterPasswordForSignupView.passwordTextFieldView.passwordTextField.isSecureTextEntry = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isSecureRePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.showPasswordButton.setImage(ImageManager.icon_RoundCehck20, for: .normal)
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.passwordTextField.isSecureTextEntry = true
                }
                else {
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.showPasswordButton.setImage(ImageManager.icon_BlueRoundCheck20, for: .normal)
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.passwordTextField.isSecureTextEntry = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isValidPassword }
            .map { !$0 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                if isValid {
                    self?.enterPasswordForSignupView.passwordTextFieldView.checkImageView.isHidden = false
                    self?.enterPasswordForSignupView.passwordTextFieldView.errorLabel.isHidden = true
                }
                else {
                    self?.enterPasswordForSignupView.passwordTextFieldView.checkImageView.isHidden = true
                    self?.enterPasswordForSignupView.passwordTextFieldView.errorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isValidRePassword }
            .map { !$0 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                if isValid {
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.checkImageView.isHidden = false
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.errorLabel.isHidden = true
                }
                else {
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.checkImageView.isHidden = true
                    self?.enterPasswordForSignupView.rePasswordTextFieldView.errorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterPasswordForSignupView.nextButton.isEnable()
                }
                else {
                    self?.enterPasswordForSignupView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
