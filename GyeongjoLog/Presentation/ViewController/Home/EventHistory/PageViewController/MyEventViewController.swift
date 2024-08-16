import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class MyEventViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let myEventView = MyEventView()
    
    init(with reactor: MyEventReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = myEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.BgMain
        self.reactor?.action.onNext(.loadMyEvent)
        self.setupTapGestureToHideSortView()
    }
    
    private func setupTapGestureToHideSortView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        guard !myEventView.sortView.isHidden else { return }
        let location = gesture.location(in: view)
        if !myEventView.sortView.frame.contains(location) &&
            !myEventView.sortButton.frame.contains(location){
            self.reactor?.action.onNext(.hideSortView)
        }
    }
}

extension MyEventViewController {
    func bind(reactor: MyEventReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MyEventReactor){
        // 버튼 탭
        myEventView.filterButton.rx.tap
            .map{ Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventView.sortButton.rx.tap
            .map{ Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventView.sortView.firstSortButton.rx.tap
            .map{ Reactor.Action.dateSortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myEventView.sortView.secondSortButton.rx.tap
            .map{ Reactor.Action.cntSortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 탭
        myEventView.myEventCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMyEvent($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.filterRelay
            .bind(onNext: { [weak self] filter in
                self?.reactor?.action.onNext(.loadFilteredMyEvent(filter))
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MyEventReactor){
        reactor.state.map { $0.myEvents }
            .distinctUntilChanged()
            .bind(to: myEventView.myEventCollectionView.rx.items(cellIdentifier: "MyEventCollectionViewCell", cellType: MyEventCollectionViewCell.self)) { index, myEvent, cell in

                cell.configure(with: myEvent)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.filterTitle }
            .distinctUntilChanged()
            .bind(to: self.myEventView.filterButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.sortTitle }
            .distinctUntilChanged()
            .bind(to: self.myEventView.sortButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isHiddenSortView }
            .distinctUntilChanged()
            .bind(to: self.myEventView.sortView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
