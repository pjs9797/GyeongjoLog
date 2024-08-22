import UIKit
import SnapKit

class IndividualStatisticsView: UIView {
    let searchView: SearchView = {
        let view = SearchView()
        view.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let relationshipFilterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6*ConstantsManager.standardWidth
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RelationshipCollectionViewCell.self, forCellWithReuseIdentifier: "RelationshipCollectionViewCell")
        return collectionView
    }()
    let noneStatistics = NoneStatisticsView()
    let individualStatisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10*ConstantsManager.standardHeight
        let itemWidth = (UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth)
        let itemHeight: CGFloat = 150 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(IndividualStatisticsCollectionViewCell.self, forCellWithReuseIdentifier: "IndividualStatisticsCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = ColorManager.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [searchView,relationshipFilterCollectionView,individualStatisticsCollectionView,noneStatistics]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(38*ConstantsManager.standardHeight)
        }
        
        relationshipFilterCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        individualStatisticsCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(relationshipFilterCollectionView.snp.bottom).offset(10*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneStatistics.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(relationshipFilterCollectionView.snp.bottom).offset(138*ConstantsManager.standardHeight)
        }
    }
}
