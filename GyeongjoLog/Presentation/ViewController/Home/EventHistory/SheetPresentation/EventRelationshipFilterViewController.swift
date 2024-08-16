import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EventRelationshipFilterViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let eventRelationshipFilterView = EventRelationshipFilterView()
    
    init(with reactor: EventRelationshipFilterReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = eventRelationshipFilterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
}

extension EventRelationshipFilterViewController {
    func bind(reactor: EventRelationshipFilterReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EventRelationshipFilterReactor){
        eventRelationshipFilterView.relationshipCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        eventRelationshipFilterView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventRelationshipFilterView.resetButton.rx.tap
            .map{ Reactor.Action.resetButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventRelationshipFilterView.selectRelationshipButton.rx.tap
            .map{ Reactor.Action.selectRelationshipButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventRelationshipFilterView.relationshipCollectionView.rx.itemSelected
            .map { Reactor.Action.selectRelationship($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EventRelationshipFilterReactor){
        reactor.state.map { $0.relationships }
            .distinctUntilChanged()
            .bind(to: eventRelationshipFilterView.relationshipCollectionView.rx.items(cellIdentifier: "RelationshipCollectionViewCell", cellType: RelationshipCollectionViewCell.self)) { index, eventType, cell in

                cell.configure(with: eventType)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableSelectRelationshipButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.eventRelationshipFilterView.selectRelationshipButton.isEnable()
                }
                else {
                    self?.eventRelationshipFilterView.selectRelationshipButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension EventRelationshipFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.relationships[index]) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.Body02
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40*ConstantsManager.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+32)*ConstantsManager.standardWidth, height: 42*ConstantsManager.standardHeight)
    }
}
