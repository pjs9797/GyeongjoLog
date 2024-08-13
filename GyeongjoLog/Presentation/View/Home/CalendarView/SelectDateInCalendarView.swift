import UIKit
import SnapKit

class SelectDateInCalendarView: UIView {
    let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text03
        return label
    }()
    let eventSummaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.rowHeight = 40*ConstantsManager.standardHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventSummaryTableViewCell.self, forCellReuseIdentifier: "EventSummaryTableViewCell")
        return tableView
    }()
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let allAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text03
        return label
    }()
    let realAllAmountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = ColorManager.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [selectedDateLabel,eventSummaryTableView,separateView,allAmountLabel,realAllAmountLabel]
            .forEach{
                addSubview($0)
            }
        
        selectedDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(44*ConstantsManager.standardHeight)
        }
        
        eventSummaryTableView.snp.makeConstraints { make in
            make.height.equalTo(130*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(eventSummaryTableView.snp.bottom)
        }
        
        allAmountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(15*ConstantsManager.standardHeight)
        }
        
        realAllAmountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(allAmountLabel.snp.top).offset(-3*ConstantsManager.standardHeight)
        }
    }
    
    func setRealAllAmountLabel(events: [Event]){
        let totalAmount = events.reduce(0) { $0 + $1.amount }
        let attributedString = NSMutableAttributedString()
        var eventCntAttributes = AttributedFontManager.Heading0101
        eventCntAttributes[.foregroundColor] = ColorManager.blue
        let eventCntString = NSAttributedString(
            string: "\(totalAmount)",
            attributes: eventCntAttributes
        )
        
        var suffixAttributes = AttributedFontManager.Body02
        suffixAttributes[.foregroundColor] = ColorManager.text01 ?? .black
        let suffixString = NSAttributedString(
            string: "원",
            attributes: suffixAttributes
        )

        attributedString.append(eventCntString)
        attributedString.append(suffixString)
        realAllAmountLabel.attributedText = attributedString
    }
}
