import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class HistoryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header, style: .plain, target: nil, action: nil)
    let calendarButton = UIBarButtonItem(image: ImageManager.icon_calendar, style: .plain, target: nil, action: nil)
    let plusButton = UIBarButtonItem(image: ImageManager.icon_plus, style: .plain, target: nil, action: nil)
    let historyView = HistoryView()
    
    init(with reactor: HistoryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
        self.reactor?.action.onNext(.loadMyEvent)
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
        navigationItem.rightBarButtonItems = [calendarButton,plusButton]
    }
}

extension HistoryViewController {
    func bind(reactor: HistoryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: HistoryReactor){
        // 버튼 탭
        calendarButton.rx.tap
            .map{ Reactor.Action.calendarButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .map{ Reactor.Action.plusButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        historyView.filterButton.rx.tap
            .map{ Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        historyView.sortButton.rx.tap
            .map{ Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 탭
        historyView.myEventCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMyEvent($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: HistoryReactor){
        reactor.state.map { $0.myEvents }
            .distinctUntilChanged()
            .bind(to: historyView.myEventCollectionView.rx.items(cellIdentifier: "MyEventCollectionViewCell", cellType: MyEventCollectionViewCell.self)) { index, myEvents, cell in

                cell.configure(with: myEvents)
//                if isSelected {
//                    self.historyView.myEventCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//                }
            }
            .disposed(by: disposeBag)
    }
}
