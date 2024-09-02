import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterEmailForFindPWViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterEmailForFindPWView = EnterEmailForFindPWView()
    
    init(with reactor: EnterEmailForFindPWReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterEmailForFindPWView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterEmailForFindPWView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterEmailForFindPWView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "비밀번호 재설정"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterEmailForFindPWViewController {
    func bind(reactor: EnterEmailForFindPWReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterEmailForFindPWReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterEmailForFindPWView.emailTextFieldView.emailTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.emailTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterEmailForFindPWView.emailTextFieldView.emailTextField.rx.text.orEmpty
            .map { Reactor.Action.inputEmailText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterEmailForFindPWView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterEmailForFindPWReactor){
        reactor.state.map{ $0.isEditingEmailTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterEmailForFindPWView.emailTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterEmailForFindPWView.emailTextFieldView.checkImageView.isHidden = false
                    self?.enterEmailForFindPWView.nextButton.isEnable()
                }
                else {
                    self?.enterEmailForFindPWView.emailTextFieldView.checkImageView.isHidden = true
                    self?.enterEmailForFindPWView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
