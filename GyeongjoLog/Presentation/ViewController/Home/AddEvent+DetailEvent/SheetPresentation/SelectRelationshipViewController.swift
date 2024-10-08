import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectRelationshipViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectRelationshipView = SelectRelationshipView()
    
    init(with reactor: SelectRelationshipReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectRelationshipView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
}

extension SelectRelationshipViewController {
    func bind(reactor: SelectRelationshipReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectRelationshipReactor){
        selectRelationshipView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectRelationshipView.selectRelationshipButton.rx.tap
            .map{ Reactor.Action.selectRelationshipButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectRelationshipView.relationshipCollectionView.rx.itemSelected
            .map { Reactor.Action.selectRelationship($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectRelationshipReactor){
        reactor.state.map { $0.relationships }
            .distinctUntilChanged()
            .bind(to: selectRelationshipView.relationshipCollectionView.rx.items(cellIdentifier: "RelationshipCollectionViewCell", cellType: RelationshipCollectionViewCell.self)) { index, eventType, cell in

                cell.configure(with: eventType)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isEnableSelectRelationshipButton }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.selectRelationshipView.selectRelationshipButton.isEnable()
                }
                else {
                    self?.selectRelationshipView.selectRelationshipButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
