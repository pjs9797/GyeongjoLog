import UIKit
import SnapKit

class NoneStatisticsView: UIView {
    let noneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.noneStatistics
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text02
        label.text = "아직 통계가 없어요"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [noneImageView,titleLabel]
            .forEach{
                addSubview($0)
            }
        
        noneImageView.snp.makeConstraints { make in
            make.width.equalTo(72*ConstantsManager.standardWidth)
            make.height.equalTo(64*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noneImageView.snp.bottom).offset(18*ConstantsManager.standardHeight)
        }
    }
}
