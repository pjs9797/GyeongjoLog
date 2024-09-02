import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EnterAuthNumberForFindPWViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let enterAuthNumberView = EnterAuthNumberView()
    
    init(with reactor: EnterAuthNumberForFindPWReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = enterAuthNumberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardExcludingButton(enterAuthNumberView.nextButton, disposeBag: disposeBag)
        bindKeyboardNotificationsForBottomButton(to: enterAuthNumberView.nextButton, disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "비밀번호 재설정"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EnterAuthNumberForFindPWViewController {
    func bind(reactor: EnterAuthNumberForFindPWReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterAuthNumberForFindPWReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        enterAuthNumberView.authNumberTextFieldView.authNumberTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.authNumberTextFieldTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberView.authNumberTextFieldView.authNumberTextField.rx.text.orEmpty
            .map { Reactor.Action.inputAuthNumberText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberView.authNumberTextFieldView.reSendButton.rx.tap
            .map{ Reactor.Action.reSendButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterAuthNumberView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterAuthNumberForFindPWReactor){
        reactor.state.map{ $0.isEditingAuthNumberTextFieldView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.enterAuthNumberView.authNumberTextFieldView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.remainingSeconds }
            .distinctUntilChanged()
            .map { seconds -> String in
                let minutes = seconds / 60
                let seconds = seconds % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .bind(to: enterAuthNumberView.authNumberTextFieldView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableNextButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.enterAuthNumberView.nextButton.isEnable()
                }
                else {
                    self?.enterAuthNumberView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
