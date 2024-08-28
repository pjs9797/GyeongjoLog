import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class AddNewEventTypeViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let addNewEventTypeView = AddNewEventTypeView()
    
    init(with reactor: AddNewEventTypeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = addNewEventTypeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        hideKeyboard(disposeBag: disposeBag)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "이벤트 추가"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension AddNewEventTypeViewController {
    func bind(reactor: AddNewEventTypeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AddNewEventTypeReactor){
        // 버튼 탭
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addNewEventTypeView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addNewEventTypeView.addEventTypeButton.rx.tap
            .map{ Reactor.Action.addEventTypeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 텍스트 필드 입력
        addNewEventTypeView.eventNameTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] text in
                let filterEventName = String(text.prefix(20))
                self?.addNewEventTypeView.eventNameTextField.text = filterEventName
                reactor.action.onNext(.inputEventNameText(filterEventName))
            })
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 탭
        addNewEventTypeView.selectColorCollectionView.rx.itemSelected
            .map { Reactor.Action.selectColor($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: AddNewEventTypeReactor){
        reactor.state.map { $0.colors }
            .distinctUntilChanged()
            .bind(to: addNewEventTypeView.selectColorCollectionView.rx.items(cellIdentifier: "SelectColorCollectionViewCell", cellType: SelectColorCollectionViewCell.self)) { index, color, cell in

                cell.configure(with: color)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.eventNameText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.addNewEventTypeView.eventNameTextField.text = text
                if text == "" {
                    self?.addNewEventTypeView.clearButton.isHidden = true
                }
                else {
                    self?.addNewEventTypeView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.nameLength }
            .distinctUntilChanged()
            .bind(to: self.addNewEventTypeView.nameLengthLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableAddEventNameButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.addNewEventTypeView.addEventTypeButton.isEnable()
                }
                else {
                    self?.addNewEventTypeView.addEventTypeButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}

