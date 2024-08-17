import UIKit
import RxSwift
import SnapKit

class RelationshipCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let relationshipLabel: UILabel = {
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
        self.relationshipLabel.textColor = isSelected ? ColorManager.blue : ColorManager.text01
        self.backgroundColor = isSelected ? ColorManager.lightBlue : ColorManager.white
        self.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
    }
    
    private func layout(){
        contentView.addSubview(relationshipLabel)
        
        relationshipLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(8*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with relationship: String) {
        relationshipLabel.text = relationship
    }
}
