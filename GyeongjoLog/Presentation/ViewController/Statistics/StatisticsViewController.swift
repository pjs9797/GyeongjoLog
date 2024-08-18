import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class StatisticsViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header2?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    let statisticsTabBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let itemWidth = (UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth) / 2
        let itemHeight: CGFloat = 30 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StatisticsTabBarCollectionViewCell.self, forCellWithReuseIdentifier: "StatisticsTabBarCollectionViewCell")
        return collectionView
    }()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: StatisticsReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.setNavigationbar()
        self.layout()
        
    }
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
    }
    
    private func layout(){
        view.addSubview(statisticsTabBarCollectionView)
        view.addSubview(pageViewController.view)
        
        statisticsTabBarCollectionView.snp.makeConstraints { make in
            make.width.equalTo(343*ConstantsManager.standardWidth)
            make.height.equalTo(30*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24*ConstantsManager.standardHeight)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(statisticsTabBarCollectionView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension StatisticsViewController {
    func bind(reactor: StatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: StatisticsReactor){
//        statisticsTabBarCollectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
        statisticsTabBarCollectionView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: StatisticsReactor){
        reactor.state.map { $0.categories }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: statisticsTabBarCollectionView.rx.items(cellIdentifier: "StatisticsTabBarCollectionViewCell", cellType: StatisticsTabBarCollectionViewCell.self)) { (index, categories, cell) in
                
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedItem }
            .observe(on:MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                guard let self = self else { return }
                let previousIndex = reactor.currentState.previousIndex
                print("previousIndex: \(previousIndex)")
                let direction: UIPageViewController.NavigationDirection = (index > previousIndex) ? .forward : .reverse
                self.pageViewController.setViewControllers([self.viewControllers[index]], direction: direction, animated: true, completion: nil)
                self.statisticsTabBarCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                reactor.action.onNext(.setPreviousIndex(index))
            })
            .disposed(by: disposeBag)
    }
}

extension StatisticsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            statisticsTabBarCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectItem(index))
        }
    }
}
