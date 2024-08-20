import UIKit
import SnapKit

class DetailIndividualStatisticsView: UIView {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Heading02
        label.textColor = ColorManager.text01
        return label
    }()
    let typeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bgGray
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        label.textColor = ColorManager.blue
        return label
    }()
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text03
        return label
    }()
    let interactionCntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text01
        return label
    }()
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text01
        return label
    }()
    let receivedSentView = ReceivedSentView()
    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "히스토리"
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text03
        return label
    }()
    let detailIndividualStatisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18*ConstantsManager.standardWidth
        let itemWidth = (UIScreen.main.bounds.width - 32*ConstantsManager.standardWidth)
        let itemHeight: CGFloat = 129 * ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DetailIndividualStatisticsCollectionViewCell.self, forCellWithReuseIdentifier: "DetailIndividualStatisticsCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [nameLabel,typeBackgroundView,typeLabel,phoneNumberLabel,interactionCntLabel,totalAmountLabel,receivedSentView,historyLabel,detailIndividualStatisticsCollectionView]
            .forEach{
                addSubview($0)
            }
        
        typeBackgroundView.addSubview(typeLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28*ConstantsManager.standardHeight)
        }
        
        typeBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(nameLabel)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.height.equalTo(16*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(nameLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        interactionCntLabel.snp.makeConstraints { make in
            make.height.equalTo(17*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        totalAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(interactionCntLabel.snp.trailing).offset(37*ConstantsManager.standardWidth)
            make.centerY.equalTo(interactionCntLabel)
        }
        
        receivedSentView.snp.makeConstraints { make in
            make.height.equalTo(87*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(interactionCntLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        historyLabel.snp.makeConstraints { make in
            make.height.equalTo(16*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(receivedSentView.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        detailIndividualStatisticsCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(historyLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
