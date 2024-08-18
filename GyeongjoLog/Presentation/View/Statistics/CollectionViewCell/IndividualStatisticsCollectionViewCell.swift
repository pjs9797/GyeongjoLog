import UIKit
import RxSwift
import SnapKit

class IndividualStatisticsCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body03
        label.textColor = ColorManager.text01
        return label
    }()
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text03
        return label
    }()
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bgGray
        view.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return view
    }()
    let interactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_interact
        return imageView
    }()
    let interactCntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        label.textColor = ColorManager.text01
        return label
    }()
    let receivedLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        label.textColor = ColorManager.text03
        return label
    }()
    let sentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        label.textColor = ColorManager.text03
        return label
    }()
    let receivedView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightBlue
        view.layer.cornerRadius = 5*ConstantsManager.standardHeight
        return view
    }()
    let sentView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.blue
        view.layer.cornerRadius = 5*ConstantsManager.standardHeight
        return view
    }()
    let receivedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0101
        label.textColor = ColorManager.text01
        label.textAlignment = .center
        return label
    }()
    let sentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0101
        label.textColor = ColorManager.text01
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.layer.borderColor = isSelected ? ColorManager.blue?.cgColor : ColorManager.lightGrayFrame?.cgColor
        self.backgroundColor = isSelected ? ColorManager.bgLightBlue : ColorManager.white
    }
    
    private func layout(){
        backView.addSubview(interactImageView)
        backView.addSubview(interactCntLabel)
        [nameLabel,phoneNumberLabel,backView,receivedLabel,sentLabel,receivedView,sentView,receivedAmountLabel,sentAmountLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(nameLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        backView.snp.makeConstraints { make in
            make.width.equalTo(63*ConstantsManager.standardWidth)
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-30*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(22*ConstantsManager.standardHeight)
        }
        
        interactImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        interactCntLabel.snp.makeConstraints { make in
            make.leading.equalTo(interactImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        receivedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
        
        sentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(receivedLabel)
        }
        
        receivedView.snp.makeConstraints { make in
            make.width.equalTo(0)
            make.height.equalTo(10*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(receivedLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        sentView.snp.makeConstraints { make in
            make.width.equalTo(0)
            make.height.equalTo(10*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(receivedView)
        }
        
        receivedAmountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(receivedView.snp.bottom).offset(5*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-17*ConstantsManager.standardHeight)
        }
        
        sentAmountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(receivedAmountLabel)
        }
    }
    
    func configure(with individualStatistics: IndividualStatistics){
        nameLabel.text = individualStatistics.name
        phoneNumberLabel.text = individualStatistics.phoneNumber
        interactCntLabel.text = "\(individualStatistics.totalInteractions)회"
        receivedAmountLabel.text = "+\(individualStatistics.totalReceivedAmount.formattedWithComma())원"
        sentAmountLabel.text = "\(individualStatistics.totalSentAmount.formattedWithComma())원"
        
        let totalReceived = CGFloat(individualStatistics.totalReceivedAmount)
        let totalSent = abs(CGFloat(individualStatistics.totalSentAmount))
        let total = totalReceived + totalSent
        
        // 각각의 비율 계산
        let receivedRatio = total > 0 ? totalReceived / total : 0
        let sentRatio = total > 0 ? totalSent / total : 0
        
        let maxWidth = contentView.frame.width - (32 * ConstantsManager.standardWidth)
        let receivedWidth = maxWidth * receivedRatio
        let sentWidth = maxWidth * sentRatio
        
        receivedView.snp.updateConstraints { make in
            make.width.equalTo(receivedWidth)
        }
        
        sentView.snp.updateConstraints { make in
            make.width.equalTo(sentWidth)
        }
        
        self.layoutIfNeeded()
    }
}
