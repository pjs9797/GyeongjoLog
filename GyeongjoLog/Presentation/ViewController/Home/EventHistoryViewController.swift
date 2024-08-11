import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EventHistoryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let calendarButton = UIBarButtonItem(image: ImageManager.icon_calendar?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let plusButton = UIBarButtonItem(image: ImageManager.icon_plus?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let historyTypeSegmentedControl: HistoryTypeSegmentedControl = {
        let segmentedControl = HistoryTypeSegmentedControl()
        return segmentedControl
    }()
    let eventHistoryView = EventHistoryView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: EventHistoryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = eventHistoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
        self.reactor?.action.onNext(.loadMyEvent)
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
        navigationItem.rightBarButtonItems = [plusButton,calendarButton]
    }
}

extension EventHistoryViewController {
    func bind(reactor: EventHistoryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EventHistoryReactor){
        // 버튼 탭
        calendarButton.rx.tap
            .map{ Reactor.Action.calendarButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .map{ Reactor.Action.plusButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventHistoryView.filterButton.rx.tap
            .map{ Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventHistoryView.sortButton.rx.tap
            .map{ Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 탭
        eventHistoryView.myEventCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMyEvent($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EventHistoryReactor){
        reactor.state.map { $0.myEvents }
            .distinctUntilChanged()
            .bind(to: eventHistoryView.myEventCollectionView.rx.items(cellIdentifier: "MyEventCollectionViewCell", cellType: MyEventCollectionViewCell.self)) { index, myEvents, cell in

                cell.configure(with: myEvents)
            }
            .disposed(by: disposeBag)
    }
}
