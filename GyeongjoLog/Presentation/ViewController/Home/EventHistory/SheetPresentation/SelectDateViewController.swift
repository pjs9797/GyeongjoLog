import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectDateViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectDateView = SelectDateView()
    
    init(with reactor: SelectDateReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
}

extension SelectDateViewController {
    func bind(reactor: SelectDateReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectDateReactor){
        selectDateView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectDateView.selectDateButton.rx.tap
            .map { reactor.eventDateRelay.accept(self.selectDateView.datePickerView.getSelectedDateString()) }
            .map{ Reactor.Action.selectDateButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectDateReactor){
    }
}
