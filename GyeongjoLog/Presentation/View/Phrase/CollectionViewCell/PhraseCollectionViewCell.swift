import UIKit
import RxSwift
import SnapKit

class PhraseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let imageBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 36*ConstantsManager.standardHeight
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    let phraseImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let phraseTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0101
        label.textColor = ColorManager.text03
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    private func layout(){
        imageBackView.addSubview(phraseImageView)
        [imageBackView,phraseTypeLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        imageBackView.snp.makeConstraints { make in
            make.width.height.equalTo(72*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        phraseImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        phraseTypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageBackView.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
    }
}
