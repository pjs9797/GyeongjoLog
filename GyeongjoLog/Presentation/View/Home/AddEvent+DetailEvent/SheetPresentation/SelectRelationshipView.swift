import UIKit
import SnapKit

class SelectRelationshipView: UIView {
    let selectRelationshipLabel: UILabel = {
        let label = UILabel()
        label.text = "관계 선택"
        label.font = FontManager.SubHead04_SemiBold
        label.textColor = ColorManager.text01
        return label
    }()
    let dismisButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_x, for: .normal)
        return button
    }()
    let relationshipCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5*ConstantsManager.standardWidth
        layout.minimumLineSpacing = 10*ConstantsManager.standardHeight
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RelationshipCollectionViewCell.self, forCellWithReuseIdentifier: "RelationshipCollectionViewCell")
        return collectionView
    }()
    let selectRelationshipButton: BottomButton = {
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
        [selectRelationshipLabel,dismisButton,relationshipCollectionView,selectRelationshipButton]
            .forEach{
                addSubview($0)
            }
        
        selectRelationshipLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        dismisButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(selectRelationshipLabel)
        }
        
        relationshipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(selectRelationshipLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        selectRelationshipButton.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
