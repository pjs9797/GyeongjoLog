import UIKit
import RxSwift
import SnapKit

class SelectColorCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let backColorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15*ConstantsManager.standardHeight
        return imageView
    }()
    let colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9*ConstantsManager.standardHeight
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        backColorImageView.backgroundColor = isSelected ? colorImageView.backgroundColor?.withAlphaComponent(0.5) : ColorManager.white
        backColorImageView.layer.borderWidth = isSelected ? 1*ConstantsManager.standardHeight : 0
        backColorImageView.layer.borderColor = isSelected ? ColorManager.bgGray?.cgColor : UIColor.clear.cgColor
    }
    
    private func layout(){
        contentView.addSubview(backColorImageView)
        backColorImageView.addSubview(colorImageView)
        
        backColorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30*ConstantsManager.standardHeight)
            make.center.equalToSuperview()
        }
        
        colorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.center.equalToSuperview()
        }
    }
    
    func configure(with color: String) {
        colorImageView.backgroundColor = UIColor(named: color)
    }
}
