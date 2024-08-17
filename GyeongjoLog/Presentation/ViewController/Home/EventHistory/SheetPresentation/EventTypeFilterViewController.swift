import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EventTypeFilterViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let eventTypeFilterView = EventTypeFilterView()
    
    init(with reactor: EventTypeFilterReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = eventTypeFilterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.reactor?.action.onNext(.loadEventTypes)
    }
}

extension EventTypeFilterViewController {
    func bind(reactor: EventTypeFilterReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EventTypeFilterReactor){
        eventTypeFilterView.eventTypeCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        eventTypeFilterView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventTypeFilterView.resetButton.rx.tap
            .map{ Reactor.Action.resetButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventTypeFilterView.selectEventButton.rx.tap
            .map{ Reactor.Action.selectEventButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventTypeFilterView.eventTypeCollectionView.rx.itemSelected
            .map { Reactor.Action.selectEventType($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EventTypeFilterReactor){
        reactor.state.map { $0.eventTypes }
            .distinctUntilChanged()
            .bind(to: eventTypeFilterView.eventTypeCollectionView.rx.items(cellIdentifier: "EventTypeCollectionViewCell", cellType: EventTypeCollectionViewCell.self)) { index, eventType, cell in

                cell.configure(with: eventType)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.selectedIndex }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] selectedIndex in
                self?.eventTypeFilterView.eventTypeCollectionView.selectItem(
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
                    self?.eventTypeFilterView.selectEventButton.isEnable()
                }
                else {
                    self?.eventTypeFilterView.selectEventButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension EventTypeFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.eventTypes[index].name) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.Body02
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40*ConstantsManager.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+32)*ConstantsManager.standardWidth, height: 42*ConstantsManager.standardHeight)
    }
}
