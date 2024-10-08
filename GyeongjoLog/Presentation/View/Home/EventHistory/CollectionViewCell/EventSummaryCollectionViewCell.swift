import UIKit
import RxSwift
import SnapKit

class EventSummaryCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var phoneNumber = ""
    let typeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bgGray
        view.layer.cornerRadius = 14*ConstantsManager.standardHeight
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
    let relationshipLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption03
        label.textColor = ColorManager.textDisabled
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.backgroundColor = isSelected ? ColorManager.bgLightBlue : ColorManager.white
        self.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
    }
    
    private func layout(){
        [typeBackgroundView,nameLabel,relationshipLabel,dateLabel,amountLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        typeBackgroundView.addSubview(typeLabel)
        
        typeBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-12*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(21*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(typeBackgroundView.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        relationshipLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(3*ConstantsManager.standardWidth)
            make.bottom.equalTo(nameLabel.snp.bottom).offset(-2*ConstantsManager.standardHeight)
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
    
    func configure(with event: Event) {
        phoneNumber = event.phoneNumber
        if let colorName = UserDefaultsManager.shared.fetchColor(forEventType: event.eventType),
           let color = UIColor(named: colorName) {
            typeLabel.textColor = color
        } else {
            typeLabel.textColor = ColorManager.text01
        }
        typeLabel.text = event.eventType
        nameLabel.text = event.name
        relationshipLabel.text = "(\(event.relationship))"
        dateLabel.text = event.date
        setAmountLabel(amount: event.amount)
    }
    
    private func setAmountLabel(amount: Int){
        let attributedString = NSMutableAttributedString()
        var eventCntAttributes = AttributedFontManager.Heading0101
        var eventCntString: NSAttributedString
        if amount > 0 {
            eventCntAttributes[.foregroundColor] = ColorManager.blue
            eventCntString = NSAttributedString(
                string: "+ \(amount.formattedWithComma())",
                attributes: eventCntAttributes
            )
        }
        else {
            eventCntAttributes[.foregroundColor] = ColorManager.red
            let absAmount = abs(amount)
            eventCntString = NSAttributedString(
                string: "- \(absAmount.formattedWithComma())",
                attributes: eventCntAttributes
            )
        }
        
        var suffixAttributes = AttributedFontManager.Body02
        suffixAttributes[.foregroundColor] = ColorManager.text01 ?? .black
        let suffixString = NSAttributedString(
            string: "원",
            attributes: suffixAttributes
        )

        attributedString.append(eventCntString)
        attributedString.append(suffixString)
        amountLabel.attributedText = attributedString
    }
}
