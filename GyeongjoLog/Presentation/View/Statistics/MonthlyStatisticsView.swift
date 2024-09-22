import UIKit
import SnapKit
import DGCharts

class MonthlyStatisticsView: UIView {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    let scrollContentView = UIView()
    let topInteractedView = TopInteractedView()
    let differenceAmountFromAverageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let receivedLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        label.text = "받음"
        return label
    }()
    let receivedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        return label
    }()
    let sentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        label.text = "보냄"
        return label
    }()
    let sentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        return label
    }()
    let barChartView = BarChartView()
    let topEventTypeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let sentPieLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text02
        return label
    }()
    let pieChartView = PieChartView()
    let pieChartDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.rowHeight = 40*ConstantsManager.standardHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PieChartTableViewCell.self, forCellReuseIdentifier: "PieChartTableViewCell")
        return tableView
    }()
    let noneStatisticsView = NoneStatisticsView()
    let nonePieView = NonePieView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBarChartAppearance()
        setupPieChartAppearance()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        [topInteractedView,differenceAmountFromAverageLabel,receivedLabel,receivedAmountLabel,sentLabel,sentAmountLabel,barChartView,topEventTypeLabel,sentPieLabel,pieChartView,pieChartDetailTableView,nonePieView,noneStatisticsView]
            .forEach{
                scrollContentView.addSubview($0)
            }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        noneStatisticsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(212*ConstantsManager.standardHeight)
        }
        
        topInteractedView.snp.makeConstraints { make in
            make.height.equalTo(134*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(28*ConstantsManager.standardHeight)
        }
        
        differenceAmountFromAverageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(topInteractedView.snp.bottom).offset(38*ConstantsManager.standardHeight)
        }
        
        receivedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(differenceAmountFromAverageLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        receivedAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(receivedLabel.snp.trailing).offset(20*ConstantsManager.standardWidth)
            make.centerY.equalTo(receivedLabel)
        }
        
        sentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(receivedLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        sentAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(sentLabel.snp.trailing).offset(20*ConstantsManager.standardWidth)
            make.centerY.equalTo(sentLabel)
        }
        
        barChartView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sentLabel.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        topEventTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(barChartView.snp.bottom).offset(48*ConstantsManager.standardHeight)
        }
        
        sentPieLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(topEventTypeLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(pieChartView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(sentPieLabel.snp.bottom).offset(-18*ConstantsManager.standardHeight)
        }
        
        pieChartDetailTableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(pieChartView.snp.bottom).offset(-29*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-109)
        }
        
        nonePieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topEventTypeLabel.snp.bottom).offset(135*ConstantsManager.standardHeight)
        }
    }
    
    private func setupBarChartAppearance() {
        // X축 관련 설정
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.granularity = 1
        self.barChartView.xAxis.labelFont = FontManager.Caption02
        self.barChartView.xAxis.labelTextColor = ColorManager.text01 ?? .black
        self.barChartView.xAxis.setLabelCount(6, force: true)

        // Y축 관련 설정
        self.barChartView.rightAxis.enabled = false
        self.barChartView.leftAxis.enabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.axisMinimum = 0
        
        // 그래프 자체 설정
        self.barChartView.legend.enabled = false
        self.barChartView.chartDescription.enabled = false
        self.barChartView.setScaleEnabled(false)
        self.barChartView.doubleTapToZoomEnabled = false
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.drawValueAboveBarEnabled = true
        self.barChartView.xAxis.drawAxisLineEnabled = false
        self.barChartView.leftAxis.drawAxisLineEnabled = false
        
        // 배경선 없애기
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false

        // 터치 인터랙션 활성화
        self.barChartView.highlightPerTapEnabled = true
        self.barChartView.isUserInteractionEnabled = true

        // 애니메이션 추가
        self.barChartView.animate(yAxisDuration: 1.5)
    }
    
    private func setupPieChartAppearance(){
        pieChartView.usePercentValuesEnabled = false
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.0
        pieChartView.transparentCircleRadiusPercent = 0.0
        pieChartView.legend.enabled = false
        pieChartView.highlightPerTapEnabled = false
        pieChartView.noDataText = ""
        
        pieChartView.extraLeftOffset = 30
        pieChartView.extraRightOffset = 30
        pieChartView.extraTopOffset = 30
        pieChartView.extraBottomOffset = 30
    }
    
    func setDifferenceAmountFromAverage(with amount: Int){
        let absAmount = abs(amount)
        if amount > 0 {
            let formattedAmount = absAmount.formattedWithComma()
            let titleText = "평균보다 \(formattedAmount)원 덜 보냈어요"
            let attributedString = NSMutableAttributedString(string: titleText)
            
            attributedString.addAttribute(.font, value: FontManager.Body03, range: NSMakeRange(0, titleText.count))
            attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
            
            let range = (titleText as NSString).range(of: formattedAmount)
            attributedString.addAttribute(.foregroundColor, value: ColorManager.blue ?? .blue, range: range)
            
            differenceAmountFromAverageLabel.attributedText = attributedString
        }
        else if amount < 0 {
            let formattedAmount = absAmount.formattedWithComma()
            let titleText = "평균보다 \(formattedAmount)원 더 보냈어요"
            let attributedString = NSMutableAttributedString(string: titleText)
            
            attributedString.addAttribute(.font, value: FontManager.Body03, range: NSMakeRange(0, titleText.count))
            attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
            
            let range = (titleText as NSString).range(of: formattedAmount)
            attributedString.addAttribute(.foregroundColor, value: ColorManager.blue ?? .blue, range: range)
            
            differenceAmountFromAverageLabel.attributedText = attributedString
        }
        else {
            let titleText = "평균과 동일하게 보냈어요"
            let attributedString = NSMutableAttributedString(string: titleText)
            
            attributedString.addAttribute(.font, value: FontManager.Body03, range: NSMakeRange(0, titleText.count))
            attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
            
            differenceAmountFromAverageLabel.attributedText = attributedString
        }
    }
    
    func setTopEventTypeLabel(month: String, eventType: String){
        let titleText = "\(month) \(eventType)에서 가장 많이 썼어요"
        let attributedString = NSMutableAttributedString(string: titleText)
        
        attributedString.addAttribute(.font, value: FontManager.SubHead03_SemiBold, range: NSMakeRange(0, titleText.count))
        attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
        
        let range = (titleText as NSString).range(of: eventType)
        attributedString.addAttribute(.foregroundColor, value: ColorManager.blue ?? .blue, range: range)
        
        topEventTypeLabel.attributedText = attributedString
    }
    
    func setNoneTopEventTypeLabel(){
        let titleText = "이번 달 보낸 내역은 없어요"
        let attributedString = NSMutableAttributedString(string: titleText)
        
        attributedString.addAttribute(.font, value: FontManager.SubHead03_SemiBold, range: NSMakeRange(0, titleText.count))
        attributedString.addAttribute(.foregroundColor, value: ColorManager.text01 ?? .black, range: NSMakeRange(0, titleText.count))
        
        topEventTypeLabel.attributedText = attributedString
    }
    
    func updateView(isEmpty: Bool) {
        if isEmpty {
            topInteractedView.isHidden = true
            differenceAmountFromAverageLabel.isHidden = true
            receivedLabel.isHidden = true
            receivedAmountLabel.isHidden = true
            sentLabel.isHidden = true
            sentAmountLabel.isHidden = true
            barChartView.isHidden = true
            topEventTypeLabel.isHidden = true
            sentPieLabel.isHidden = true
            pieChartView.isHidden = true
            pieChartDetailTableView.isHidden = true
            nonePieView.isHidden = true
            
            noneStatisticsView.isHidden = false
            
            // noneStatisticsView를 중앙에 배치
//            noneStatisticsView.snp.remakeConstraints { make in
//                make.center.equalToSuperview()
//            }
        } 
        else {
            // 모든 뷰를 보이게 하고 noneStatisticsView를 숨깁니다.
            topInteractedView.isHidden = false
            differenceAmountFromAverageLabel.isHidden = false
            receivedLabel.isHidden = false
            receivedAmountLabel.isHidden = false
            sentLabel.isHidden = false
            sentAmountLabel.isHidden = false
            barChartView.isHidden = false
            topEventTypeLabel.isHidden = false
            sentPieLabel.isHidden = false
            pieChartView.isHidden = false
            pieChartDetailTableView.isHidden = false
            nonePieView.isHidden = false
            
            noneStatisticsView.isHidden = true
            
            // 기존 레이아웃으로 복원
            //layout()
        }
    }

}
