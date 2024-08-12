//import UIKit
//import SnapKit
//import FSCalendar
//
//class CalendarView: UIView {
//    let yearMonthButton: UIButton = {
//        let button = UIButton()
//        button.setTitleColor(ColorManager.text01, for: .normal)
//        button.setTitleColor(ColorManager.text01?.withAlphaComponent(0.8), for: .highlighted)
//        //button.titleLabel?.font = FontManager
//        return button
//    }()
//    let leftButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .gray
//        return button
//    }()
//    let rightButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .black
//        return button
//    }()
//    let calendar = FSCalendar()
//    let myEventCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 11*ConstantsManager.standardWidth
//        layout.minimumLineSpacing = 14*ConstantsManager.standardHeight
//        let itemWidth = ((UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth) - 11*ConstantsManager.standardWidth) / 2
//        let itemHeight: CGFloat = 129 * ConstantsManager.standardHeight
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.register(MyEventCollectionViewCell.self, forCellWithReuseIdentifier: "MyEventCollectionViewCell")
//        return collectionView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        layout()
//        self.backgroundColor = ColorManager.BgMain
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func layout() {
//        [filterButton,sortButton,myEventCollectionView]
//            .forEach{
//                addSubview($0)
//            }
//        
//        filterButton.snp.makeConstraints { make in
//            make.height.equalTo(17*ConstantsManager.standardHeight)
//            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
//            make.top.equalToSuperview().offset(24*ConstantsManager.standardHeight)
//        }
//        
//        sortButton.snp.makeConstraints { make in
//            make.height.equalTo(17*ConstantsManager.standardHeight)
//            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
//            make.centerY.equalTo(filterButton)
//        }
//        
//        myEventCollectionView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
//            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
//            make.top.equalTo(filterButton.snp.bottom).offset(14*ConstantsManager.standardHeight)
//            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
//        }
//    }
//}
