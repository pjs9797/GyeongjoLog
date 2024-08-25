import UIKit
import DGCharts
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class MonthlyStatisticsViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let monthlyStatisticsView = MonthlyStatisticsView()
    
    init(with reactor: MonthlyStatisticsReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = monthlyStatisticsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        
        monthlyStatisticsView.barChartView.delegate = self
        self.reactor?.action.onNext(.loadMonthlyStatistics)
        self.reactor?.action.onNext(.selectMonth(5))
        self.reactor?.action.onNext(.loadTopIndividualStatistics)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.loadMonthlyStatistics)
        self.reactor?.action.onNext(.loadTopIndividualStatistics)
    }
    
    private func setTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTopInteractedViewTap))
        monthlyStatisticsView.topInteractedView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTopInteractedViewTap() {
        reactor?.action.onNext(.selectTopIndividual)
    }
}

extension MonthlyStatisticsViewController {
    func bind(reactor: MonthlyStatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MonthlyStatisticsReactor){
        
    }
    
    func bindState(reactor: MonthlyStatisticsReactor){
        reactor.state.map { $0.topName }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] name in
                self?.monthlyStatisticsView.topInteractedView.configureTopInteractedView(name: name)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.topIndividualStatistic }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] topIndividualStatistic in
                if let topIndividualStatistic = topIndividualStatistic {
                    self?.monthlyStatisticsView.topInteractedView.configureCnt(cnt: topIndividualStatistic.eventDetails.count)
                }
                else {
                    self?.monthlyStatisticsView.topInteractedView.configureCnt(cnt: 0)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.monthlyStatistics }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] statistics in
                self?.updateBarChart(statistics: statistics)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmptyMonthlyStatistics }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] isEmpty in
                self?.monthlyStatisticsView.updateView(isEmpty: isEmpty)
            }
            .disposed(by: disposeBag)
        
        // 평균과의 차이 업데이트
        reactor.state.map { $0.differenceAmountFromAverage }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] amount in
                self?.monthlyStatisticsView.setDifferenceAmountFromAverage(with: amount)
            })
            .disposed(by: disposeBag)
        
        // 받은 금액 라벨 업데이트
        reactor.state.map { $0.receivedAmount }
            .distinctUntilChanged()
            .bind(to: monthlyStatisticsView.receivedAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 보낸 금액 라벨 업데이트
        reactor.state.map { $0.sentAmount }
            .distinctUntilChanged()
            .bind(to: monthlyStatisticsView.sentAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 선택된 달이 변경될 때 파이 차트 및 라벨 업데이트
        reactor.state.compactMap { $0.selectedMonthlyStatistics }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedMonth in
                self?.updatePieChart(for: selectedMonth)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.topEventType }
            .distinctUntilChanged { (previous, current) in
                return previous == current
            }
            .bind(onNext: { [weak self] (month,eventType) in
                if eventType == "" {
                    self?.monthlyStatisticsView.setNoneTopEventTypeLabel()
                }
                else {
                    self?.monthlyStatisticsView.topEventTypeLabel.isHidden = false
                    self?.monthlyStatisticsView.setTopEventTypeLabel(month: month, eventType: eventType)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.sentPieText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                if text == "이번달 총 0원을 썼어요" {
                    self?.monthlyStatisticsView.sentPieLabel.isHidden = true
                }
                else {
                    self?.monthlyStatisticsView.sentPieLabel.isHidden = false
                    self?.monthlyStatisticsView.sentPieLabel.text = text
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.pieChartDetails }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: monthlyStatisticsView.pieChartDetailTableView.rx.items(cellIdentifier: "PieChartTableViewCell", cellType: PieChartTableViewCell.self)) { index, event, cell in
                
                cell.configure(with: event)
                cell.setColorImageView(index: index)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.pieChartDetails }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] pieChartDetails in
                if pieChartDetails.isEmpty {
                    self?.monthlyStatisticsView.nonePieView.isHidden = false
                }
                else {
                    self?.monthlyStatisticsView.nonePieView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        monthlyStatisticsView.pieChartDetailTableView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] height in
                self?.monthlyStatisticsView.pieChartDetailTableView.snp.updateConstraints { make in
                    make.height.equalTo(height * ConstantsManager.standardHeight)
                }
            })
            .disposed(by: disposeBag)
    }
}

// 막대 그래프
extension MonthlyStatisticsViewController: ChartViewDelegate {
    private func calculateNormalizedHeight(for transactionCount: Int, maxTransactionCount: Int) -> Double {
        let minHeight = 2.0*ConstantsManager.standardHeight
        let maxHeight = 110.0*ConstantsManager.standardHeight
        
        guard maxTransactionCount > 0 else {
            return minHeight
        }
        
        // 정규화된 높이 계산 (0 <= transactionCount <= maxTransactionCount 사이의 값)
        let normalizedHeight = (Double(transactionCount) / Double(maxTransactionCount)) * (maxHeight - minHeight) + minHeight
        
        return normalizedHeight
    }
    
    private func updateBarChart(statistics: [MonthlyStatistics]) {
        var entries: [BarChartDataEntry] = []
        
        // X축 레이블로 사용할 dataPoints 생성
        let dataPoints = statistics.map { statistic -> String in
            let components = statistic.month.split(separator: ".")
            return components.count == 2 ? "\(components[1])월" : ""
        }
        
        // 최대 건수 찾기
        let maxTransactionCount = statistics.max(by: { $0.transactionCount < $1.transactionCount })?.transactionCount ?? 0
        
        for (index, statistic) in statistics.enumerated() {
            // 건수에 따라 높이 계산
            let height = calculateNormalizedHeight(for: statistic.transactionCount, maxTransactionCount: maxTransactionCount)
            
            // transactionCount를 data로 추가
            let entry = BarChartDataEntry(x: Double(index), y: height, data: statistic.transactionCount as AnyObject)
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "")
        
        // 막대의 기본 색상은 라이트 블루로 설정, 선택된 막대는 블루로 설정
        dataSet.colors = Array(repeating: ColorManager.lightBlue ?? .lightBlue, count: entries.count)
        
        // 막대 위의 값 라벨 표시 설정
        dataSet.valueFormatter = TransactionCountValueFormatter()
        dataSet.valueColors = Array(repeating: ColorManager.text03 ?? .gray, count: entries.count)
        dataSet.valueFont = FontManager.Body02
        
        // 막대 데이터가 선택되었을 때 색상 및 텍스트 색상 업데이트
        dataSet.highlightColor = ColorManager.blue ?? .blue
        
        let data = BarChartData(dataSet: dataSet)
        
        // 데이터 포인트 X축 레이블 설정
        monthlyStatisticsView.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // X축 레이블 간의 간격을 강제로 조정하여 모든 레이블이 표시되도록 설정
        monthlyStatisticsView.barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        
        monthlyStatisticsView.barChartView.data = data
        monthlyStatisticsView.barChartView.notifyDataSetChanged()
        
        if statistics.indices.contains(5) {
            monthlyStatisticsView.barChartView.highlightValue(x: 5, dataSetIndex: 0, callDelegate: true)
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] as? BarChartDataSet else {
            return
        }
        
        // 모든 막대의 색상을 기본 색상으로 설정
        dataSet.colors = Array(repeating: ColorManager.lightBlue ?? .lightBlue, count: dataSet.count)
        
        // 선택된 막대의 색상을 블루로 변경
        if let index = dataSet.entries.firstIndex(of: entry) {
            dataSet.colors[index] = ColorManager.blue ?? .blue
            reactor?.action.onNext(.selectMonth(index))
        }
        
        // 차트 다시 그리기
        chartView.notifyDataSetChanged()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        guard let dataSet = chartView.data?.dataSets.first as? BarChartDataSet else {
            return
        }
        
        // 모든 막대의 색상을 기본 색상으로 설정
        dataSet.colors = Array(repeating: ColorManager.lightBlue ?? .lightBlue, count: dataSet.count)
        
        // 차트 다시 그리기
        chartView.notifyDataSetChanged()
    }
}


class TransactionCountValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        // entry.data에 저장된 transactionCount를 가져와서 라벨로 사용
        if let transactionCount = entry.data as? Int {
            return "\(transactionCount)"
        }
        return ""
    }
}

// 파이 차트
extension MonthlyStatisticsViewController {
    private func updatePieChart(for selectedMonth: MonthlyStatistics) {
        var entries: [PieChartDataEntry] = []
        let eventTypeAmounts = selectedMonth.eventTypeAmounts.sorted {
            if abs($0.value) != abs($1.value) {
                return abs($0.value) > abs($1.value)
            }
            else {
                return $0.key.localizedStandardCompare($1.key) == .orderedAscending
            }
        }
        let topThreeEventTypes = eventTypeAmounts.prefix(3).reversed()
        
        let colors: [NSUIColor] = [ColorManager.cobaltBlue ?? .blue, ColorManager.blue ?? .gray, ColorManager.skyBlue ?? .lightGray].reversed()
        
        for (index, (eventType, amount)) in topThreeEventTypes.enumerated() {
            let entry = PieChartDataEntry(value: Double(abs(amount)), label: eventType)
            entries.append(entry)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = Array(colors.prefix(entries.count))
        dataSet.sliceSpace = 0
        dataSet.selectionShift = 0
        
        // 라벨을 차트 내부로 설정
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .insideSlice
        
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        
        // 라벨 (이벤트 타입) 스타일 설정
        dataSet.entryLabelFont = FontManager.Body02
        dataSet.entryLabelColor = ColorManager.white ?? .white
        
        monthlyStatisticsView.pieChartView.rotationAngle = 270
        monthlyStatisticsView.pieChartView.data = data
        monthlyStatisticsView.pieChartView.notifyDataSetChanged()
    }
}
