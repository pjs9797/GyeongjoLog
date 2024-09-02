import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterPasswordForFindPWViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterPasswordView = EnterPasswordView()
    
    init(with reactor: EnterPasswordForFindPWReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterPasswordView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterPasswordView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
        self.enterPasswordView.nextButton.setTitle("비밀번호 변경", for: .normal)
    }
    
    private func setNavigationbar() {
        self.title = "비밀번호 재설정"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterPasswordForFindPWViewController {
    func bind(reactor: EnterPasswordForFindPWReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterPasswordForFindPWReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterPasswordView.passwordTextFieldView.passwordTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.passwordTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.passwordTextFieldView.passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.inputPasswordText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.passwordTextFieldView.showPasswordButton.rx.tap
            .map{ Reactor.Action.showPasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.rePasswordTextFieldView.passwordTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.rePasswordTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.rePasswordTextFieldView.passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.inputRePasswordText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.rePasswordTextFieldView.showPasswordButton.rx.tap
            .map{ Reactor.Action.showRePasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterPasswordView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterPasswordForFindPWReactor){
        reactor.state.map{ $0.isEditingPasswordTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterPasswordView.passwordTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEditingRePasswordTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterPasswordView.rePasswordTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isSecurePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.enterPasswordView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_RoundCehck20, for: .normal)
                    self?.enterPasswordView.passwordTextFieldView.passwordTextField.isSecureTextEntry = true
                }
                else {
                    self?.enterPasswordView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_BlueRoundCheck20, for: .normal)
                    self?.enterPasswordView.passwordTextFieldView.passwordTextField.isSecureTextEntry = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isSecureRePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.enterPasswordView.rePasswordTextFieldView.showPasswordButton.setImage(ImageManager.icon_RoundCehck20, for: .normal)
                    self?.enterPasswordView.rePasswordTextFieldView.passwordTextField.isSecureTextEntry = true
                }
                else {
                    self?.enterPasswordView.rePasswordTextFieldView.showPasswordButton.setImage(ImageManager.icon_BlueRoundCheck20, for: .normal)
                    self?.enterPasswordView.rePasswordTextFieldView.passwordTextField.isSecureTextEntry = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isValidPassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                if isValid {
                    self?.enterPasswordView.passwordTextFieldView.checkImageView.isHidden = false
                    self?.enterPasswordView.passwordTextFieldView.errorLabel.isHidden = true
                }
                else {
                    self?.enterPasswordView.passwordTextFieldView.checkImageView.isHidden = true
                    self?.enterPasswordView.passwordTextFieldView.errorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isValidRePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                if isValid {
                    self?.enterPasswordView.rePasswordTextFieldView.checkImageView.isHidden = false
                    self?.enterPasswordView.rePasswordTextFieldView.errorLabel.isHidden = true
                }
                else {
                    self?.enterPasswordView.rePasswordTextFieldView.checkImageView.isHidden = true
                    self?.enterPasswordView.rePasswordTextFieldView.errorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterPasswordView.nextButton.isEnable()
                }
                else {
                    self?.enterPasswordView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
