import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectEventDateViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectEventDateView = SelectEventDateView()
    
    init(with reactor: SelectEventDateReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectEventDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
}

extension SelectEventDateViewController {
    func bind(reactor: SelectEventDateReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectEventDateReactor){
        selectEventDateView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectEventDateView.selectDateButton.rx.tap
            .map { reactor.eventDateRelay.accept(self.selectEventDateView.datePickerView.getSelectedDateString()) }
            .map{ Reactor.Action.selectDateButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectEventDateReactor){
    }
}
