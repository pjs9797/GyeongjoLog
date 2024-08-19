import UIKit
import SnapKit

class IndividualStatisticsView: UIView {
    let topInteractedView = TopInteractedView()
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RelationshipCollectionViewCell.self, forCellWithReuseIdentifier: "RelationshipCollectionViewCell")
        return collectionView
    }()
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
        topInteractedView.configure(with: "가나다", cnt: 6)
        self.backgroundColor = ColorManager.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [topInteractedView,searchView,relationshipFilterCollectionView,individualStatisticsCollectionView]
            .forEach{
                addSubview($0)
            }
        
        topInteractedView.snp.makeConstraints { make in
            make.height.equalTo(134*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(topInteractedView.snp.bottom).offset(30*ConstantsManager.standardHeight)
        }
        
        relationshipFilterCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        individualStatisticsCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(relationshipFilterCollectionView.snp.bottom).offset(18*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
