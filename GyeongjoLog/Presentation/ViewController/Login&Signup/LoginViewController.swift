import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let loginView = LoginView()
    
    init(with reactor: LoginReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard(disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "로그인"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension LoginViewController {
    func bind(reactor: LoginReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: LoginReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        loginView.emailTextFieldView.emailTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.emailTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.emailTextFieldView.emailTextField.rx.text.orEmpty
            .map { Reactor.Action.inputEmailText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.passwordTextFieldView.passwordTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.passwordTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.passwordTextFieldView.passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.inputPasswordText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.passwordTextFieldView.showPasswordButton.rx.tap
            .map{ Reactor.Action.showPasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.loginButton.rx.tap
            .map{ Reactor.Action.loginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.findPasswordButton.rx.tap
            .map{ Reactor.Action.findPasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: LoginReactor){
        reactor.state.map{ $0.isEditingEmailTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.loginView.emailTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEditingPasswordTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.loginView.passwordTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isSecurePassword }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.loginView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_RoundCehck20, for: .normal)
                    self?.loginView.passwordTextFieldView.passwordTextField.isSecureTextEntry = true
                }
                else {
                    self?.loginView.passwordTextFieldView.showPasswordButton.setImage(ImageManager.icon_BlueRoundCheck20, for: .normal)
                    self?.loginView.passwordTextFieldView.passwordTextField.isSecureTextEntry = false
                }
            })
            .disposed(by: disposeBag)
    }
}
