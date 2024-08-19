import UIKit
import RxSwift
import SnapKit

class StatisticsTabBarCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.SubHead03_SemiBold
        label.textColor = ColorManager.textDisabled
        label.textAlignment = .center
        return label
    }()
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let selectedUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.blue
        view.layer.cornerRadius = 1.5*ConstantsManager.standardHeight
        view.isHidden = true
        return view
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
        categoryLabel.textColor = isSelected ? ColorManager.blue : ColorManager.textDisabled
        selectedUnderLineView.isHidden = isSelected ? false : true
    }
    
    private func layout(){
        [categoryLabel,underLineView,selectedUnderLineView]
            .forEach{
                contentView.addSubview($0)
            }
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.top.equalTo(categoryLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        selectedUnderLineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(3*ConstantsManager.standardHeight)
            make.centerY.equalTo(underLineView)
        }
    }
}
