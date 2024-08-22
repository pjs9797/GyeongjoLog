import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class PhraseViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header3, style: .plain, target: nil, action: nil)
    let phraseView = PhraseView()
    
    init(with reactor: PhraseReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = phraseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
    }
}

extension PhraseViewController {
    func bind(reactor: PhraseReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PhraseReactor){
    }
    
    func bindState(reactor: PhraseReactor){
        
    }
}
