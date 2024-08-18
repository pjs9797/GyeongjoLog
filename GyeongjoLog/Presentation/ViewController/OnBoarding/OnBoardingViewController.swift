import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class OnBoardingViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let pageControl = UIPageControl()
    private let viewControllers: [UIViewController]
    private let startButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("시작하기", for: .normal)
        button.isEnable()
        return button
    }()
    
    init(with reactor: OnBoardingReactor) {
        self.viewControllers = [
            ImageViewController(image: UIImage(named: "onBoarding1")!),
            ImageViewController(image: UIImage(named: "onBoarding2")!),
            ImageViewController(image: UIImage(named: "onBoarding3")!),
            ImageViewController(image: UIImage(named: "onBoarding4")!)
        ]
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorManager.white
        setupPageViewController()
        setupPageControl()
        layout()
    }

    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstViewController = viewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    private func setupPageControl() {
        pageControl.numberOfPages = viewControllers.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = ColorManager.black
        pageControl.pageIndicatorTintColor = ColorManager.lightGraySelection
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let currentIndex = pageViewController.viewControllers?.first.flatMap { viewControllers.firstIndex(of: $0) } ?? 0
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([viewControllers[sender.currentPage]], direction: direction, animated: true, completion: nil)
    }

    private func layout() {
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        pageViewController.view.snp.makeConstraints { make in
            make.height.equalTo(490*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(58*ConstantsManager.standardHeight)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageViewController.view.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(62*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30*ConstantsManager.standardHeight)
        }
    }
}

extension OnBoardingViewController {
    func bind(reactor: OnBoardingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: OnBoardingReactor){
        // 버튼 탭
        startButton.rx.tap
            .map{ Reactor.Action.startButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 페이지 전환 시 Reactor에 페이지 설정
        pageControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.setPage(self.pageControl.currentPage) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: OnBoardingReactor){
        reactor.state.map { $0.currentPage }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, page in
                let direction: UIPageViewController.NavigationDirection = page > owner.pageControl.currentPage ? .forward : .reverse
                
                owner.pageViewController.setViewControllers([owner.viewControllers[page]], direction: direction, animated: true, completion: nil)
                owner.pageControl.currentPage = page
            })
            .disposed(by: disposeBag)

    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < (viewControllers.count - 1) else {
            return nil
        }
        return viewControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: visibleViewController) {
            reactor?.action.onNext(.setPage(index))
        }
    }
}
