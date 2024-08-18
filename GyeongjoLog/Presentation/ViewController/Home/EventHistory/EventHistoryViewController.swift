import UIKit
import SnapKit
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
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: EventHistoryReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.BgMain
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.setNavigationbar()
        self.layout()
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
        navigationItem.rightBarButtonItems = [plusButton,calendarButton]
    }
    
    private func layout(){
        view.addSubview(historyTypeSegmentedControl)
        view.addSubview(pageViewController.view)
        
        historyTypeSegmentedControl.snp.makeConstraints { make in
            make.height.equalTo(47*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30*ConstantsManager.standardHeight)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(historyTypeSegmentedControl.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
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
        
        // 세그먼트 컨트롤 선택 시 액션
        historyTypeSegmentedControl.rx.selectedSegmentIndex
            .map { Reactor.Action.selectSegment($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EventHistoryReactor){
        reactor.state.map { $0.selectedItem }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, index in
                let direction: UIPageViewController.NavigationDirection = (index > owner.reactor?.currentState.previousIndex ?? 0) ? .forward : .reverse
                owner.pageViewController.setViewControllers([owner.viewControllers[index]], direction: direction, animated: true, completion: nil)
                owner.reactor?.action.onNext(.setPreviousIndex(index))
            })
            .disposed(by: disposeBag)

    }
}

extension EventHistoryViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < (viewControllers.count - 1) else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: visibleViewController) {
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectSegment(index))
        }
    }
}
