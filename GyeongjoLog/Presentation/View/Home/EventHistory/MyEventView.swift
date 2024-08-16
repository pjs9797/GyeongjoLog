import UIKit
import SnapKit

class MyEventView: UIView {
    let filterButton = FilterButton()
    let sortButton = SortButton()
    let sortView: SortView = {
        let view = SortView()
        view.secondSortButton.setTitle("건수", for: .normal)
        return view
    }()
    let myEventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 11*ConstantsManager.standardWidth
        layout.minimumLineSpacing = 14*ConstantsManager.standardHeight
        let itemWidth = ((UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth) - 11*ConstantsManager.standardWidth) / 2
        let itemHeight: CGFloat = 129 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.BgMain
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MyEventCollectionViewCell.self, forCellWithReuseIdentifier: "MyEventCollectionViewCell")
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
        [filterButton,sortButton,myEventCollectionView,sortView]
            .forEach{
                addSubview($0)
            }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(24*ConstantsManager.standardHeight)
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
        
        myEventCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(filterButton.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
