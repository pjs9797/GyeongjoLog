import UIKit
import RxSwift
import SnapKit

class PhraseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let imageBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 36*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.bgGray
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
        self.imageBackView.backgroundColor = isSelected ? ColorManager.bgLightBlue : ColorManager.bgGray
        self.imageBackView.layer.borderWidth = isSelected ? 1 : 0
        self.imageBackView.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : UIColor.clear.cgColor
        self.phraseTypeLabel.textColor = isSelected ? ColorManager.blue : ColorManager.text03
    }
    
    private func layout(){
        [imageBackView,phraseTypeLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        imageBackView.addSubview(phraseImageView)
        
        imageBackView.snp.makeConstraints { make in
            make.width.height.equalTo(72*ConstantsManager.standardHeight).priority(.high)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        phraseImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        phraseTypeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageBackView)
            make.top.equalTo(imageBackView.snp.bottom).offset(10*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with type: String){
        phraseTypeLabel.text = type
        if type == "결혼식" {
            phraseImageView.image = ImageManager.phrase_ring
        }
        else if type == "장례식" {
            phraseImageView.image = ImageManager.phrase_ribbon
        }
        else if type == "생일" {
            phraseImageView.image = ImageManager.phrase_cake
        }
        else if type == "돌잔치" {
            phraseImageView.image = ImageManager.phrase_birth
        }
    }
}
