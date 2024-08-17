import UIKit
import RxSwift
import SnapKit

class EventAmountCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body02
        label.textColor = ColorManager.text01
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20*ConstantsManager.standardHeight
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        updateUI()
    }

    private func updateUI() {
        self.amountLabel.textColor = isSelected ? ColorManager.blue : ColorManager.text01
        self.backgroundColor = isSelected ? ColorManager.bgLightBlue : ColorManager.white
        self.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
    }

    
    private func layout(){
        contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with amount: Int) {
        amountLabel.text = "\(amount)만"
    }
}
