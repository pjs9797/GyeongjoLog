import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header4, style: .plain, target: nil, action: nil)
    let settingView = SettingView()
    
    init(with reactor: SettingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}

extension SettingViewController {
    func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor){
        settingView.settingTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        settingView.settingTableView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingReactor){
        reactor.state.map { $0.settings }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: settingView.settingTableView.rx.items(cellIdentifier: "SettingTableViewCell", cellType: SettingTableViewCell.self)) { index, setting, cell in

                cell.configure(with: setting)
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == numberOfRows - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } 
        else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
