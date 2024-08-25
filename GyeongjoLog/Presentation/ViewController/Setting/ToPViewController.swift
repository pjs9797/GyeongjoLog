import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ToPViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let toPView = ToPView()
    
    init(with reactor: ToPReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = toPView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "개인정보 처리방침"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension ToPViewController {
    func bind(reactor: ToPReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ToPReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: ToPReactor){
        reactor.state.map { $0.toP }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.toPView.setToPText(text: text)
            })
            .disposed(by: disposeBag)
    }
}
