import UIKit
import RxSwift
import SnapKit

class EventTypeCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var originalTextColor: UIColor?
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body02
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 18
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
        self.eventTypeLabel.textColor = isSelected ? ColorManager.blue : originalTextColor
        self.backgroundColor = isSelected ? ColorManager.lightBlue : ColorManager.white
        self.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
    }
    
    private func layout(){
        contentView.addSubview(eventTypeLabel)
        
        eventTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(8*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with eventType: EventType) {
        eventTypeLabel.text = eventType.name
        eventTypeLabel.textColor = UIColor(named: eventType.color) ?? ColorManager.text01
        originalTextColor = UIColor(named: eventType.color) ?? ColorManager.text01
        updateUI()
    }
}
