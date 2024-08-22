import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailIndividualStatisticsViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let detailIndividualStatisticsView = DetailIndividualStatisticsView()
    
    init(with reactor: DetailIndividualStatisticsReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = detailIndividualStatisticsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "개인별 상세"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension DetailIndividualStatisticsViewController {
    func bind(reactor: DetailIndividualStatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailIndividualStatisticsReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailIndividualStatisticsReactor){
        reactor.state.map{ $0.name }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.phoneNumber }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.phoneNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.relationship }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.totalInteractions }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.interactionCntLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.totalAmount }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.totalReceivedAmount }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.receivedSentView.receivedAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.totalSentAmount }
            .distinctUntilChanged()
            .bind(to: self.detailIndividualStatisticsView.receivedSentView.sentAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.eventDetails }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.detailIndividualStatisticsView.detailIndividualStatisticsCollectionView.rx.items(cellIdentifier: "DetailIndividualStatisticsCollectionViewCell", cellType: DetailIndividualStatisticsCollectionViewCell.self)) { index, eventDetail, cell in

                cell.configure(with: eventDetail)
            }
            .disposed(by: disposeBag)
        
    }
}
