import UIKit
import RxSwift
import SnapKit

class EventSummaryCollectionViewCell: UICollectionViewCell {
    let typeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bgGray
        view.layer.cornerRadius = 16*ConstantsManager.standardHeight
        return view
    }()
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body03
        label.textColor = ColorManager.text01
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text03
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body03
        label.textColor = ColorManager.blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [typeBackgroundView,nameLabel,dateLabel,amountLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        typeBackgroundView.addSubview(typeLabel)
        
        typeBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(typeBackgroundView.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(nameLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-32*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with eventSummary: EventSummary) {
        if let colorName = UserDefaultsManager.shared.fetchColor(forEventType: eventSummary.eventType),
           let color = UIColor(named: colorName) {
            typeLabel.textColor = color
        } else {
            typeLabel.textColor = ColorManager.text01
        }
        typeLabel.text = eventSummary.eventType
        nameLabel.text = eventSummary.name
        dateLabel.text = eventSummary.date
        if eventSummary.amount > 0 {
            amountLabel.textColor = ColorManager.blue
            amountLabel.text = "\(eventSummary.amount)원"
        }
        else {
            amountLabel.textColor = ColorManager.red
            amountLabel.text = "\(eventSummary.amount)원"
        }
        
//        let attributedString = NSMutableAttributedString()
//        var eventCntAttributes = AttributedFontManager.Heading02
//        eventCntAttributes[.foregroundColor] = ColorManager.blue ?? .blue
//        let eventCntString = NSAttributedString(
//            string: "\(myEvent.eventCnt)",
//            attributes: eventCntAttributes
//        )
//        
//        var suffixAttributes = AttributedFontManager.SubHead02_SemiBold
//        suffixAttributes[.foregroundColor] = ColorManager.text01 ?? .black
//        let suffixString = NSAttributedString(
//            string: "건",
//            attributes: suffixAttributes
//        )
//
//        attributedString.append(eventCntString)
//        attributedString.append(suffixString)
//        cntLabel.attributedText = attributedString
    }
}
