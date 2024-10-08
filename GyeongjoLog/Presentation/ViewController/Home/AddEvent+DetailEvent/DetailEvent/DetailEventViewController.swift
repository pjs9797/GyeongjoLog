import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class DetailEventViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let deleteButton = UIBarButtonItem(image: ImageManager.icon_trash, style: .plain, target: nil, action: nil)
    let addEventView = AddEventView()
    private let expandedCollectionViewHeight: CGFloat = 95*ConstantsManager.standardHeight
    private let collapsedCollectionViewHeight: CGFloat = 0
    
    init(with reactor: DatailEventReactor) {
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
        bindKeyboardNotifications(to: addEventView.scrollView, button: addEventView.addEventButton, textView: addEventView.memoTextView, in: addEventView, disposeBag: disposeBag)
        self.setNavigationbar()
        switch self.reactor?.addEventFlow{
        case .myEventSummary:
            addEventView.amountView.titleLabel.text = "받은 금액"
        case .othersEventSummary:
            addEventView.amountView.titleLabel.text = "보낸 금액"
        case .none:
            addEventView.amountView.titleLabel.text = "금액"
        }
        self.addEventView.addEventButton.setTitle("수정하기", for: .normal)
    }
    
    private func setNavigationbar() {
        self.title = "상세 내역"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    private func toggleAmountCollectionView(expand: Bool) {
        let newHeight = expand ? expandedCollectionViewHeight : collapsedCollectionViewHeight
        addEventView.amountCollectionView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
        
        // memoLabel, memoTextView, addEventButton 위치 조정
        if expand {
            addEventView.memoLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
                make.top.equalTo(addEventView.amountCollectionView.snp.bottom).offset(24 * ConstantsManager.standardHeight)
            }
        } else {
            addEventView.memoLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
                make.top.equalTo(addEventView.amountView.snp.bottom).offset(32 * ConstantsManager.standardHeight)
            }
        }
    }
    
}

extension DetailEventViewController {
    func bind(reactor: DatailEventReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DatailEventReactor){
        addEventView.amountView.contentTextField.delegate = self
        
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
            .skip(1)
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
            .skip(1)
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
            .skip(1)
            .map{ Reactor.Action.inputAmountText($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.amountView.clearButton.rx.tap
            .map { Reactor.Action.amountViewClearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.amountCollectionView.rx.itemSelected
            .map { Reactor.Action.selectAmount($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 메모 뷰
        addEventView.memoTextView.rx.didBeginEditing
            .map{ Reactor.Action.memoTextViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addEventView.memoTextView.rx.text.orEmpty
            .skip(1)
            .map{ Reactor.Action.inputMemoText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let tapActions: [Observable<Void>] = [
            addEventView.nameView.nameTextField.rx.controlEvent([.editingDidBegin]).asObservable(),
            addEventView.phoneNumberView.contentTextField.rx.controlEvent([.editingDidBegin]).asObservable(),
            addEventView.eventTypeView.contentButton.rx.tap.asObservable(),
            addEventView.dateView.contentButton.rx.tap.asObservable(),
            addEventView.relationshipView.contentButton.rx.tap.asObservable(),
            addEventView.memoTextView.rx.didBeginEditing.asObservable()
        ]
        
        Observable.merge(tapActions)
            .subscribe(onNext: { [weak self] in
                self?.toggleAmountCollectionView(expand: false)
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DatailEventReactor){
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
        
        reactor.state.map { $0.name }
            .take(1)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.addEventView.nameView.updateWidthForNonEditing()
                self?.addEventView.nameView.nameTextField.text = text
                self?.addEventView.nameView.clearButton.isHidden = true
                self?.addEventView.nameView.pencilImageView.isHidden = false
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
                self?.toggleAmountCollectionView(expand: isEditing)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.formattedAmount }
            .distinctUntilChanged()
            .bind(to: addEventView.amountView.contentTextField.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.eventAmounts }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: addEventView.amountCollectionView.rx.items(cellIdentifier: "EventAmountCollectionViewCell", cellType: EventAmountCollectionViewCell.self)) { index, amount, cell in
                let filterAmount = Int(amount) / 10000
                cell.configure(with: filterAmount)
            }
            .disposed(by: disposeBag)
        
        // 메모 뷰
        reactor.state.map{ $0.isEditingMemoTextView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEditing in
                self?.addEventView.memoTextView.layer.borderColor = isEditing ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap{ $0.memo }
            .distinctUntilChanged()
            .bind(to: self.addEventView.memoTextView.rx.text)
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

extension DetailEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text else {
            return true
        }
        
        // "원"과 "," 제거
        var text = currentText.replacingOccurrences(of: "원", with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        
        let isOthersEvent = reactor?.addEventFlow == .othersEventSummary
        let isMyEvent = reactor?.addEventFlow == .myEventSummary
        
        if isOthersEvent {
            text = text.replacingOccurrences(of: "- ", with: "")
        } else if isMyEvent {
            text = text.replacingOccurrences(of: "+ ", with: "")
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        var newText: String
        if string.isEmpty {
            // delete operation
            if text.count == 1 {
                // 마지막 숫자를 지우는 경우 전체 텍스트 제거
                textField.text = ""
                self.reactor?.action.onNext(.inputAmountText(""))
                return false
            } else {
                newText = String(text.prefix(text.count - 1))
            }
        } else {
            // add operation
            newText = "\(text)\(string)"
        }
        
        // 숫자 포맷팅
        guard let price = Int(newText) else {
            return true
        }
        guard let formattedAmountText = numberFormatter.string(from: NSNumber(value: price)) else {
            return true
        }
        
        // NSAttributedString 생성
        let formattedText = (isOthersEvent ? "- " : (isMyEvent ? "+ " : "")) + formattedAmountText
        let attributedText = NSMutableAttributedString(string: formattedText, attributes: [
            .font: FontManager.Heading0101
        ])
        let wonText = NSAttributedString(string: "원", attributes: [
            .font: FontManager.Body02
        ])
        attributedText.append(wonText)
        
        // NSAttributedString을 UITextField에 설정
        textField.attributedText = attributedText
        
        // 커서를 "원" 앞에 위치시킴
        if let position = textField.position(from: textField.endOfDocument, offset: -1) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        
        // Reactor에 새로운 텍스트 전달
        self.reactor?.action.onNext(.inputAmountText(newText + "원"))
        
        return false
    }
}
