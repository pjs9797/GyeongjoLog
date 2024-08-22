import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectCalendarDateViewController: DimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectCalendarDateView = SelectCalendarDateView()
    
    init(with reactor: SelectCalendarDateViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCalendarDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
    }
}

extension SelectCalendarDateViewController {
    func bind(reactor: SelectCalendarDateViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCalendarDateViewReactor){
        selectCalendarDateView.dismisButton.rx.tap
            .map{ Reactor.Action.dismissButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCalendarDateView.selectDateButton.rx.tap
            .map { reactor.eventDateRelay.accept(self.selectCalendarDateView.yearMonthDatePickerView.getSelectedDateString()) }
            .map{ Reactor.Action.selectDateButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCalendarDateViewReactor){
        reactor.state.map { $0.selectedDate }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] selectedDate in
                let components = selectedDate.split(separator: ".").compactMap { Int($0) }
                guard components.count == 2 else { return }
                
                self?.selectCalendarDateView.yearMonthDatePickerView.selectedYear = components[0]
                self?.selectCalendarDateView.yearMonthDatePickerView.selectedMonth = components[1]
                
                self?.selectCalendarDateView.yearMonthDatePickerView.selectCurrentDate()
            })
            .disposed(by: disposeBag)
    }
}
