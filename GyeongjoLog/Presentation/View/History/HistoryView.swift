import UIKit
import SnapKit

class HistoryView: UIView {
    let historyTypeSegmentedControl: HistoryTypeSegmentedControl = {
        let segmentedControl = HistoryTypeSegmentedControl()
        return segmentedControl
    }()
    let filterButton: FilterButton = {
        let button = FilterButton()
        return button
    }()
    let sortButton: SortButton = {
        let button = SortButton()
        return button
    }()
    let myEventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 11*ConstantsManager.standardWidth
        layout.minimumLineSpacing = 15*ConstantsManager.standardHeight
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MyEventCollectionViewCell.self, forCellWithReuseIdentifier: "MyEventCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [historyTypeSegmentedControl,filterButton,sortButton,myEventCollectionView]
            .forEach{
                addSubview($0)
            }
        
        historyTypeSegmentedControl.snp.makeConstraints { make in
            make.height.equalTo(47*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30*ConstantsManager.standardHeight)
        }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(historyTypeSegmentedControl.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        sortButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(filterButton)
        }
        
        myEventCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(filterButton.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
