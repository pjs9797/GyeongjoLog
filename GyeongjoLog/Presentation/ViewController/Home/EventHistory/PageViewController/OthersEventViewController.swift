import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class OthersEventViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let othersEventView = OthersEventView()
    
    init(with reactor: OthersEventReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = othersEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard(disposeBag: disposeBag)
        view.backgroundColor = ColorManager.BgMain
        self.reactor?.action.onNext(.loadOthersEventSummary)
        self.setupTapGestureToHideSortView()
    }
    
    private func setupTapGestureToHideSortView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        guard !othersEventView.sortView.isHidden else { return }
        let location = gesture.location(in: view)
        if !othersEventView.sortView.frame.contains(location) &&
            !othersEventView.sortButton.frame.contains(location) {
            self.reactor?.action.onNext(.hideSortView)
        }
    }
}

extension OthersEventViewController {
    func bind(reactor: OthersEventReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: OthersEventReactor){
        // 버튼 탭
        othersEventView.filterButton.rx.tap
            .map{ Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        othersEventView.sortButton.rx.tap
            .map{ Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        othersEventView.sortView.firstSortButton.rx.tap
            .map{ Reactor.Action.dateSortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        othersEventView.sortView.secondSortButton.rx.tap
            .map{ Reactor.Action.cntSortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        othersEventView.searchView.searchTextField.rx.text.orEmpty
            .map { Reactor.Action.updateSearchTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.filterRelay
            .bind(onNext: { [weak self] filter in
                self?.reactor?.action.onNext(.loadFilteredOthersEventSummary(filter))
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: OthersEventReactor){
        reactor.state.map { $0.othersEventSummaries }
            .distinctUntilChanged()
            .bind(to: othersEventView.othersEventSummaryCollectionView.rx.items(cellIdentifier: "EventSummaryCollectionViewCell", cellType: EventSummaryCollectionViewCell.self)) { index, othersEvent, cell in

                cell.configure(with: othersEvent)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.filterTitle }
            .distinctUntilChanged()
            .bind(to: self.othersEventView.filterButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.sortTitle }
            .distinctUntilChanged()
            .bind(to: self.othersEventView.sortButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isHiddenSortView }
            .distinctUntilChanged()
            .bind(to: self.othersEventView.sortView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
