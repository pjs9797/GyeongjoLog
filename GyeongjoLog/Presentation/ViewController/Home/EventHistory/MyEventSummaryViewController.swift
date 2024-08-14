import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class MyEventSummaryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let calendarButton = UIBarButtonItem(image: ImageManager.icon_calendar?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let plusButton = UIBarButtonItem(image: ImageManager.icon_plus?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let myEventSummaryView = MyEventSummaryView()
    
    init(with reactor: MyEventSummaryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = myEventSummaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard(disposeBag: disposeBag)
        self.reactor?.action.onNext(.loadMyEventSummary)
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [plusButton,calendarButton]
    }
}

extension MyEventSummaryViewController {
    func bind(reactor: MyEventSummaryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MyEventSummaryReactor){
        // 버튼 탭
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarButton.rx.tap
            .map{ Reactor.Action.calendarButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .map{ Reactor.Action.plusButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventSummaryView.filterButton.rx.tap
            .map{ Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventSummaryView.sortButton.rx.tap
            .map{ Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventSummaryView.searchView.searchTextField.rx.text.orEmpty
            .map { Reactor.Action.updateSearchTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MyEventSummaryReactor){
        reactor.state.map{ $0.eventType }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] type in
                self?.myEventSummaryView.setBackground(eventType: type)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredMyEventSummaries }
            .distinctUntilChanged()
            .bind(to: myEventSummaryView.myEventSummaryCollectionView.rx.items(cellIdentifier: "EventSummaryCollectionViewCell", cellType: EventSummaryCollectionViewCell.self)) { index, myEvent, cell in

                cell.configure(with: myEvent)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.amount }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] amount in
                self?.myEventSummaryView.amountLabelText(amount: amount, eventType: reactor.currentState.eventType)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.eventCnt }
            .distinctUntilChanged()
            .bind(to: self.myEventSummaryView.cntLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
