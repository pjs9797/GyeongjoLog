import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterEmailForSignupViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterEmailForSignupView = EnterEmailForSignupView()
    
    init(with reactor: EnterEmailForSignupReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterEmailForSignupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterEmailForSignupView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterEmailForSignupView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "회원가입"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterEmailForSignupViewController {
    func bind(reactor: EnterEmailForSignupReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterEmailForSignupReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterEmailForSignupView.emailTextFieldView.emailTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.emailTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterEmailForSignupView.emailTextFieldView.emailTextField.rx.text.orEmpty
            .map { Reactor.Action.inputEmailText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterEmailForSignupView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterEmailForSignupReactor){
        reactor.state.map{ $0.isEditingEmailTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterEmailForSignupView.emailTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterEmailForSignupView.emailTextFieldView.checkImageView.isHidden = false
                    self?.enterEmailForSignupView.nextButton.isEnable()
                }
                else {
                    self?.enterEmailForSignupView.emailTextFieldView.checkImageView.isHidden = true
                    self?.enterEmailForSignupView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
