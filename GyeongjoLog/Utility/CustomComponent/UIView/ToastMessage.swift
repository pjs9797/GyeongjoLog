import UIKit
import SnapKit

class ToastMessage: UIView {
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_blueRoundCheck
        return imageView
    }()
    let toastLabel: UILabel = {
        let label = UILabel()
        label.text = "복사가 완료되었어요"
        label.font = FontManager.Body0201
        label.textColor = ColorManager.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 24*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.lightGray01
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [checkImageView, toastLabel]
            .forEach{
                addSubview($0)
            }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(18*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

