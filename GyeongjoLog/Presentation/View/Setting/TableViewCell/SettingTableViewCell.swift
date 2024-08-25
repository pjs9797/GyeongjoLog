import UIKit
import RxSwift
import SnapKit

class SettingTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text01
        return label
    }()
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_right24
        return imageView
    }()
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 1.0"
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text03
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func layout(){
        [titleLabel,rightImageView,versionLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-20*ConstantsManager.standardHeight)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
    }
    
    func configure(with title: String){
        titleLabel.text = title
        
        if title == "앱 버전" {
            rightImageView.isHidden = true
            versionLabel.isHidden = false
        }
        else {
            rightImageView.isHidden = false
            versionLabel.isHidden = true
        }
    }
}
