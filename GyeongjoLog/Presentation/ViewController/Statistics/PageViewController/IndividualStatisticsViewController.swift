import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class IndividualStatisticsViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let individualStatisticsView = IndividualStatisticsView()
    
    init(with reactor: IndividualStatisticsReactor) {
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
        
        hideKeyboard(disposeBag: disposeBag)
        view.backgroundColor = ColorManager.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.loadIndividualStatistics)
        self.individualStatisticsView.searchView.searchTextField.text = nil
    }
}

extension IndividualStatisticsViewController {
    func bind(reactor: IndividualStatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IndividualStatisticsReactor){
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
    
    func bindState(reactor: IndividualStatisticsReactor){
        reactor.state.map { $0.relationships }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: individualStatisticsView.relationshipFilterCollectionView.rx.items(cellIdentifier: "RelationshipCollectionViewCell", cellType: RelationshipCollectionViewCell.self)) { index, relationship, cell in

                cell.configure(with: relationship)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.individualStatistics }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: individualStatisticsView.individualStatisticsCollectionView.rx.items(cellIdentifier: "IndividualStatisticsCollectionViewCell", cellType: IndividualStatisticsCollectionViewCell.self)) { index, individualStatistic, cell in

                cell.configure(with: individualStatistic)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.individualStatistics }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] individualStatistics in
                if individualStatistics.isEmpty {
                    self?.individualStatisticsView.noneStatistics.isHidden = false
                }
                else {
                    self?.individualStatisticsView.noneStatistics.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
