import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectEventTypeViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectEventTypeView = SelectEventTypeView()
    
    init(with reactor: SelectEventTypeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectEventTypeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.reactor?.action.onNext(.loadEventTypes)
    }
}

extension SelectEventTypeViewController {
    func bind(reactor: SelectEventTypeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectEventTypeReactor){
        selectEventTypeView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectEventTypeView.selectEventButton.rx.tap
            .map{ Reactor.Action.selectEventButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectEventTypeView.addNewEventTypeButton.rx.tap
            .map{ Reactor.Action.addNewEventTypeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectEventTypeView.eventTypeCollectionView.rx.itemSelected
            .map { Reactor.Action.selectEventType($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectEventTypeReactor){
        reactor.state.map { $0.eventTypes }
            .distinctUntilChanged()
            .bind(to: selectEventTypeView.eventTypeCollectionView.rx.items(cellIdentifier: "EventTypeCollectionViewCell", cellType: EventTypeCollectionViewCell.self)) { index, eventType, cell in

                cell.configure(with: eventType)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.selectedIndex }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] selectedIndex in
                self?.selectEventTypeView.eventTypeCollectionView.selectItem(
                    at: IndexPath(item: selectedIndex, section: 0),
                    animated: false,
                    scrollPosition: .centeredVertically
                )
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableSelectEventButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.selectEventTypeView.selectEventButton.isEnable()
                }
                else {
                    self?.selectEventTypeView.selectEventButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
