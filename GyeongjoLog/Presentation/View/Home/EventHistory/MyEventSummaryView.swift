import UIKit
import SnapKit

class MyEventSummaryView: UIView {
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Heading02
        label.numberOfLines = 2
        return label
    }()
    let cntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.SubTitle01
        label.textColor = ColorManager.text03
        return label
    }()
    let imageView = UIImageView()
    let searchView = SearchView()
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.white
        view.layer.cornerRadius = 16*ConstantsManager.standardHeight
        return view
    }()
    let filterButton = FilterButton()
    let sortButton = SortButton()
    let sortView: SortView = {
        let view = SortView()
        view.secondSortButton.setTitle("금액순", for: .normal)
        return view
    }()
    let myEventSummaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10*ConstantsManager.standardHeight
        let itemWidth = UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth
        let itemHeight: CGFloat = 122 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EventSummaryCollectionViewCell.self, forCellWithReuseIdentifier: "EventSummaryCollectionViewCell")
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
        [amountLabel,cntLabel,imageView,searchView,backView]
            .forEach{
                addSubview($0)
            }
        [filterButton,sortButton,myEventSummaryCollectionView,sortView]
            .forEach{
                backView.addSubview($0)
            }
        
        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30*ConstantsManager.standardHeight)
        }
        
        cntLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(amountLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(120*ConstantsManager.standardWidth)
            make.height.equalTo(93*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-31*ConstantsManager.standardWidth)
            make.top.equalTo(amountLabel.snp.top).offset(32*ConstantsManager.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(cntLabel.snp.bottom).offset(52*ConstantsManager.standardHeight)
        }
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(20*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(28*ConstantsManager.standardHeight)
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
        
        myEventSummaryCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(filterButton.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func setBackground(eventType: String){
        if eventType == "결혼식" {
            self.backgroundColor = UIColor(hex: "FFEEFF")
            self.imageView.image = UIImage(named: "ring")
        }
        else if eventType == "장례식" {
            self.backgroundColor = UIColor(hex: "E7E7E7")
            self.imageView.image = UIImage(named: "ribbon")
        }
        else if eventType == "생일" {
            self.backgroundColor = UIColor(hex: "E5E4FE")
            self.imageView.image = UIImage(named: "cake")
        }
        else if eventType == "돌잔치" {
            self.backgroundColor = UIColor(hex: "FFF5EA")
            self.imageView.image = UIImage(named: "birth")
        }
        else {
            self.backgroundColor = ColorManager.bgLightBlue
            self.imageView.image = UIImage(named: "present")
        }
    }
    
    func amountLabelText(amount: Int, eventType: String){
        let formattedAmount = amount.formattedWithComma()
        
        var type: String = ""
        if eventType == "결혼식" || eventType == "돌잔치" {
            type = "축의금"
        }
        else if eventType == "장례식" {
            type = "조의금"
        }
        else if eventType == "생일" {
            type = "생일 선물"
        }
        else {
            type = "선물"
        }
        let fullText = "총 \(formattedAmount)원의\n\(type)을 받았어요"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let amountRange = (fullText as NSString).range(of: formattedAmount)
        attributedString.addAttribute(.foregroundColor, value: ColorManager.black ?? .black, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.foregroundColor, value: ColorManager.blue ?? .blue, range: amountRange)
        
        amountLabel.attributedText = attributedString
    }
}
