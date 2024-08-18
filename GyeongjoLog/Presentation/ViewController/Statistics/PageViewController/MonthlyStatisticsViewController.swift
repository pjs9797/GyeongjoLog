import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class MonthlyStatisticsViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let individualStatisticsView = IndividualStatisticsView()
    
    init(with reactor: MonthlyStatisticsReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = individualStatisticsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.loadIndividualStatistics)
    }
}

extension MonthlyStatisticsViewController {
    func bind(reactor: MonthlyStatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MonthlyStatisticsReactor){
        individualStatisticsView.relationshipFilterCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 검색
        individualStatisticsView.searchView.searchTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateSearchTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 탭
        individualStatisticsView.relationshipFilterCollectionView.rx.itemSelected
            .map { Reactor.Action.selectRelationship($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        individualStatisticsView.individualStatisticsCollectionView.rx.itemSelected
            .map{ Reactor.Action.selectIndividualStatistics($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MonthlyStatisticsReactor){
        reactor.state.map { $0.relationships }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: individualStatisticsView.relationshipFilterCollectionView.rx.items(cellIdentifier: "RelationshipCollectionViewCell", cellType: RelationshipCollectionViewCell.self)) { index, relationship, cell in

                cell.configure(with: relationship)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.individualStatistics }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: individualStatisticsView.individualStatisticsCollectionView.rx.items(cellIdentifier: "IndividualStatisticsCollectionViewCell", cellType: IndividualStatisticsCollectionViewCell.self)) { index, individualStatistic, cell in

                cell.configure(with: individualStatistic)
            }
            .disposed(by: disposeBag)
    }
}

extension MonthlyStatisticsViewController: UICollectionViewDelegateFlowLayout {
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
