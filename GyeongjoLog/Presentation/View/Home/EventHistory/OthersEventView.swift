import UIKit
import SnapKit

class OthersEventView: UIView {
    let searchView = SearchView()
    let filterButton = FilterButton()
    let sortButton = SortButton()
    let sortView: SortView = {
        let view = SortView()
        view.secondSortButton.setTitle("금액순", for: .normal)
        return view
    }()
    let noneOthersEventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.noneOthersEvent
        return imageView
    }()
    let noneOthersEventLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 기록이 없어요"
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text02
        return label
    }()
    let othersEventSummaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10*ConstantsManager.standardHeight
        let itemWidth = UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth
        let itemHeight: CGFloat = 122 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.BgMain
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EventSummaryCollectionViewCell.self, forCellWithReuseIdentifier: "EventSummaryCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = ColorManager.BgMain
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [searchView,filterButton,sortButton,noneOthersEventImageView,noneOthersEventLabel,othersEventSummaryCollectionView,sortView]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(30*ConstantsManager.standardHeight)
        }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(searchView.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        sortButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(filterButton)
        }
        
        sortView.snp.makeConstraints { make in
            make.width.equalTo(140*ConstantsManager.standardWidth)
            make.height.equalTo(130*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(sortButton.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        noneOthersEventImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(168*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-228*ConstantsManager.standardHeight)
        }
        
        noneOthersEventLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noneOthersEventImageView.snp.bottom).offset(18*ConstantsManager.standardHeight)
        }
        
        othersEventSummaryCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(filterButton.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
