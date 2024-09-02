import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class BeginingViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let beginingView = BeginingView()
    
    init(with reactor: BeginingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = beginingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension BeginingViewController {
    func bind(reactor: BeginingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: BeginingReactor){
        beginingView.loginButton.rx.tap
            .map{ Reactor.Action.loginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        beginingView.signupButton.rx.tap
            .map{ Reactor.Action.signupButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        beginingView.startNotLoginButton.rx.tap
            .map{ Reactor.Action.startNotLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: BeginingReactor){
        
    }
}
