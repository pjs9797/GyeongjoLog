import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class AddEventViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let deleteButton = UIBarButtonItem(image: ImageManager.icon_trash, style: .plain, target: nil, action: nil)
    let addEventView = AddEventView()
    
    init(with reactor: AddEventReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = addEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        hideKeyboard(disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "내역추가"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteButton
    }
}

extension AddEventViewController {
    func bind(reactor: AddEventReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AddEventReactor){
        // 네비게이션 버튼, 하단 버튼 탭
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map{ Reactor.Action.deleteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.addEventButton.rx.tap
            .map{ Reactor.Action.addEventButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 이름 뷰
        addEventView.nameView.nameTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.nameViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.nameView.nameTextField.rx.text.orEmpty
            .map { Reactor.Action.inputNameText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.nameView.clearButton.rx.tap
            .map { Reactor.Action.nameViewClearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 전화번호 뷰
        addEventView.phoneNumberView.contentTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.phoneNumberViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.phoneNumberView.contentTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] phoneNumber in
                let filterPhoneNumber = String(phoneNumber.prefix(13))
                self?.addEventView.phoneNumberView.contentTextField.text = filterPhoneNumber
                reactor.action.onNext(.inputPhoneNumberText(filterPhoneNumber))
            })
            .disposed(by: disposeBag)
        
        addEventView.phoneNumberView.clearButton.rx.tap
            .map { Reactor.Action.phoneNumberViewClearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 이벤트 타입 뷰
        addEventView.eventTypeView.contentButton.rx.tap
            .map{ Reactor.Action.eventTypeViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.eventTypeRelay
            .bind(onNext: { [weak self] eventType in
                self?.reactor?.action.onNext(.inputEventTypeTitle(eventType))
            })
            .disposed(by: disposeBag)
        
        // 날짜 뷰
        addEventView.dateView.contentButton.rx.tap
            .map{ Reactor.Action.dateViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.eventDateRelay
            .bind(onNext: { [weak self] date in
                self?.reactor?.action.onNext(.inputDateTitle(date))
            })
            .disposed(by: disposeBag)
        
        // 관계 뷰
        addEventView.relationshipView.contentButton.rx.tap
            .map{ Reactor.Action.relationshipViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.eventRelationshipRelay
            .bind(onNext: { [weak self] relationship in
                self?.reactor?.action.onNext(.inputRelationshipTitle(relationship))
            })
            .disposed(by: disposeBag)
        
        // 금액 뷰
        addEventView.amountView.contentTextField.rx.controlEvent([.editingDidBegin])
            .map{ Reactor.Action.amountViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.amountView.contentTextField.rx.text.orEmpty
            .map{ Reactor.Action.inputAmountText($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.amountView.clearButton.rx.tap
            .map { Reactor.Action.amountViewClearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: AddEventReactor){
        // 이름 뷰
        reactor.state.map { $0.isEditingSetNameView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.nameView.bottomBorderView.isHidden = !isEditing
                self?.addEventView.nameView.clearButton.isHidden = !isEditing
                self?.addEventView.nameView.pencilImageView.isHidden = isEditing
                if self?.addEventView.nameView.nameTextField.text == "" {
                    self?.addEventView.nameView.clearButton.isHidden = true
                    self?.addEventView.nameView.pencilImageView.isHidden = false
                }
                if isEditing {
                    self?.addEventView.nameView.updateWidthForEditing()
                }
                if !isEditing {
                    self?.addEventView.nameView.updateWidthForNonEditing()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.addEventView.nameView.textFieldDidChange(text)
                self?.addEventView.nameView.nameTextField.text = text
                if text == "" {
                    self?.addEventView.nameView.clearButton.isHidden = true
                    self?.addEventView.nameView.pencilImageView.isHidden = false
                }
                else {
                    self?.addEventView.nameView.clearButton.isHidden = false
                    self?.addEventView.nameView.pencilImageView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        // 전화번호 뷰
        reactor.state.map{ $0.isEditingPhoneNumberView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.phoneNumberView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.phoneNumber }
            .distinctUntilChanged()
            .bind(to: self.addEventView.phoneNumberView.contentTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 이벤트 타입 뷰
        reactor.state.map{ $0.isEditingEventTypeView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.eventTypeView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.eventType }
            .distinctUntilChanged()
            .bind(to: self.addEventView.eventTypeView.contentButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        // 날짜 뷰
        reactor.state.map{ $0.isEditingDateView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.dateView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.date }
            .distinctUntilChanged()
            .bind(to: self.addEventView.dateView.contentButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        // 관계 뷰
        reactor.state.map{ $0.isEditingRelationshipView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.relationshipView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.relationship }
            .distinctUntilChanged()
            .bind(to: self.addEventView.relationshipView.contentButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        // 금액 뷰
        reactor.state.map{ $0.isEditingAmountView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.amountView.configureView(isEditing: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.amount }
            .distinctUntilChanged()
            .bind(to: self.addEventView.amountView.contentTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableAddEventButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.addEventView.addEventButton.isEnable()
                }
                else {
                    self?.addEventView.addEventButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
