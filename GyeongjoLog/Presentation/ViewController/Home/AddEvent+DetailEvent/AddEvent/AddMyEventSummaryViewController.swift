import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class AddMyEventSummaryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let addEventView = AddEventView()
    private let expandedCollectionViewHeight: CGFloat = 95*ConstantsManager.standardHeight
    private let collapsedCollectionViewHeight: CGFloat = 0
    
    init(with reactor: AddMyEventSummaryReactor) {
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
        self.setAddEventView()
    }
    
    private func setNavigationbar() {
        self.title = "내역추가"
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setAddEventView(){
        self.addEventView.amountView.titleLabel.text = "받은 금액"
        self.addEventView.eventTypeView.contentButton.isEnabled = false
        self.addEventView.dateView.contentButton.isEnabled = false
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
        
        // 애니메이션 적용
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.layoutIfNeeded()
        })
    }
    
}

extension AddMyEventSummaryViewController {
    func bind(reactor: AddMyEventSummaryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AddMyEventSummaryReactor){
        addEventView.amountView.contentTextField.delegate = self
        addEventView.amountCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 네비게이션 버튼, 하단 버튼 탭
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
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
    
    func bindState(reactor: AddMyEventSummaryReactor){
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
        
        reactor.state.map{ $0.eventType }
            .distinctUntilChanged()
            .bind(to: self.addEventView.eventTypeView.contentButton.rx.title(for: .normal))
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
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
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

extension AddMyEventSummaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = "\(reactor?.currentState.eventAmounts[index] ?? 0)"
        let label = UILabel()
        label.text = text
        label.font = FontManager.Body02
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40*ConstantsManager.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width)*ConstantsManager.standardWidth, height: 40*ConstantsManager.standardHeight)
    }
}

extension AddMyEventSummaryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text else {
            return true
        }
        
        // "원"과 "," 제거
        var text = currentText.replacingOccurrences(of: "원", with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: "+ ", with: "")
        
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
        let formattedText = "+ " + formattedAmountText
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
