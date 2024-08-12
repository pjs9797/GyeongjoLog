import UIKit
import SnapKit

class SelectEventTypeView: UIView {
    let selectEventLabel: UILabel = {
        let label = UILabel()
        label.text = "이벤트 선택"
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
        layout.minimumInteritemSpacing = 10*ConstantsManager.standardHeight
        layout.minimumLineSpacing = 6*ConstantsManager.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventTypeCollectionViewCell.self, forCellWithReuseIdentifier: "EventTypeCollectionViewCell")
        return collectionView
    }()
    let selectEventButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("선택하기", for: .normal)
        return button
    }()
    let addEventTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("이벤트 추가하기", for: .normal)
        button.titleLabel?.font = FontManager.Caption01
        button.setTitleColor(ColorManager.text03, for: .normal)
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
        [selectEventLabel,dismisButton,eventTypeCollectionView,selectEventButton,addEventTypeButton]
            .forEach{
                addSubview($0)
            }
        
        selectEventLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        dismisButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(selectEventLabel)
        }
        
        eventTypeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(selectEventLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        selectEventButton.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-42*ConstantsManager.standardHeight)
        }
        
        addEventTypeButton.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(selectEventButton.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
