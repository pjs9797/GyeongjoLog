import UIKit
import SnapKit

class EventTypeFilterView: UIView {
    let selectFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "필터 선택"
        label.font = FontManager.SubHead04_SemiBold
        label.textColor = ColorManager.text01
        return label
    }()
    let dismisButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_x, for: .normal)
        return button
    }()
    let eventTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6*ConstantsManager.standardWidth
        layout.minimumLineSpacing = 10*ConstantsManager.standardHeight
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventTypeCollectionViewCell.self, forCellWithReuseIdentifier: "EventTypeCollectionViewCell")
        return collectionView
    }()
    let resetButton = ResetButton()
    let selectEventButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("선택하기", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [selectFilterLabel,dismisButton,eventTypeCollectionView,resetButton,selectEventButton]
            .forEach{
                addSubview($0)
            }
        
        selectFilterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        dismisButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(selectFilterLabel)
        }
        
        eventTypeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(138*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(selectFilterLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        resetButton.snp.makeConstraints { make in
            make.width.equalTo(89*ConstantsManager.standardWidth)
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
        
        selectEventButton.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalTo(resetButton.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
