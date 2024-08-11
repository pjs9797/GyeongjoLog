import UIKit
import RxSwift
import SnapKit

class MyEventCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let typeLabel: UILabel = {
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
    let cntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body03
        label.textColor = ColorManager.text03
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
        [typeLabel,dateLabel,cntLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        typeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel.snp.leading)
            make.top.equalTo(typeLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        cntLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-20*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with myEvent: MyEvent) {
        typeLabel.text = myEvent.eventType
        dateLabel.text = myEvent.date
        
        let attributedString = NSMutableAttributedString()
        var eventCntAttributes = AttributedFontManager.Heading02
        eventCntAttributes[.foregroundColor] = ColorManager.blue ?? .blue
        let eventCntString = NSAttributedString(
            string: "\(myEvent.eventCnt)",
            attributes: eventCntAttributes
        )
        
        var suffixAttributes = AttributedFontManager.SubHead02_SemiBold
        suffixAttributes[.foregroundColor] = ColorManager.text01 ?? .black
        let suffixString = NSAttributedString(
            string: "건",
            attributes: suffixAttributes
        )

        attributedString.append(eventCntString)
        attributedString.append(suffixString)
        cntLabel.attributedText = attributedString
    }
}
