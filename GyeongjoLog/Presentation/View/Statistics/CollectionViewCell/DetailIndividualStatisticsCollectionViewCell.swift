import UIKit
import SnapKit

class DetailIndividualStatisticsCollectionViewCell: UICollectionViewCell {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text01
        return label
    }()
    let pointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.pointPoint
        return imageView
    }()
    let leftCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.blue
        view.layer.cornerRadius = 12 * ConstantsManager.standardHeight
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    let rightCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.white
        view.frame.size.width = 10*ConstantsManager.standardWidth
        view.frame.size.height = 98*ConstantsManager.standardHeight
        
        view.layer.addBorder([.top,.bottom], color: ColorManager.lightGrayFrame ?? .gray, width: 1)
        return view
    }()
    let eventTypeAmountBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text01
        return label
    }()
    let amountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body01
        label.textColor = ColorManager.text01
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let interactionBackView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bgGray
        view.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return view
    }()
    let interactionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let interactionLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption
        label.textColor = ColorManager.text01
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [dateLabel,pointImageView,eventTypeAmountBackView,leftCoverView,rightCoverView]
            .forEach{
                contentView.addSubview($0)
            }
        
        [eventTypeLabel,amountTypeLabel,amountLabel,interactionBackView]
            .forEach{
                eventTypeAmountBackView.addSubview($0)
            }
        
        [interactionImageView,interactionLabel]
            .forEach{
                interactionBackView.addSubview($0)
            }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        pointImageView.snp.makeConstraints { make in
            make.width.equalTo(2*ConstantsManager.standardWidth)
            make.height.equalTo(90*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        eventTypeAmountBackView.snp.makeConstraints { make in
            make.width.equalTo(330*ConstantsManager.standardWidth)
            make.height.equalTo(98*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.top.equalTo(pointImageView.snp.top)
        }
        
        leftCoverView.snp.makeConstraints { make in
            make.width.equalTo(20*ConstantsManager.standardWidth)
            make.height.equalTo(98*ConstantsManager.standardHeight)
            make.leading.equalTo(eventTypeAmountBackView.snp.leading)
            make.centerY.equalTo(eventTypeAmountBackView)
        }
        
        rightCoverView.snp.makeConstraints { make in
            make.width.equalTo(10*ConstantsManager.standardWidth)
            make.height.equalTo(98*ConstantsManager.standardHeight)
            make.leading.equalTo(leftCoverView.snp.centerX)
            make.centerY.equalTo(eventTypeAmountBackView)
        }
        
        eventTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(21*ConstantsManager.standardHeight)
        }
        
        amountTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(eventTypeLabel.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(amountTypeLabel.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.centerY.equalTo(amountTypeLabel)
        }
        
        interactionBackView.snp.makeConstraints { make in
            make.width.equalTo(65*ConstantsManager.standardWidth)
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-40*ConstantsManager.standardWidth)
            make.centerY.equalTo(eventTypeLabel)
        }
        
        interactionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        interactionLabel.snp.makeConstraints { make in
            make.leading.equalTo(interactionImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with eventDetail: EventDetail){
        dateLabel.text = eventDetail.date
        eventTypeLabel.text = eventDetail.eventType
        if eventDetail.eventType == "결혼식" || eventDetail.eventType == "돌잔치" {
            amountTypeLabel.text = "축의금"
        }
        else if eventDetail.eventType == "장례식" {
            amountTypeLabel.text = "조의금"
        }
        else if eventDetail.eventType == "생일" {
            amountTypeLabel.text = "생일 선물"
        }
        else {
            amountTypeLabel.text = "선물"
        }
        setAmountLabel(amount: eventDetail.amount)
        
        if eventDetail.amount > 0 {
            interactionImageView.image = ImageManager.icon_received
            interactionLabel.text = "받음"
            leftCoverView.backgroundColor = ColorManager.blue
        }
        else {
            interactionImageView.image = ImageManager.icon_sent
            interactionLabel.text = "보냄"
            leftCoverView.backgroundColor = ColorManager.lightPink
        }
    }
    
    private func setAmountLabel(amount: Int){
        let attributedString = NSMutableAttributedString()
        var eventCntAttributes = AttributedFontManager.Body02
        var eventCntString: NSAttributedString
        if amount > 0 {
            eventCntAttributes[.foregroundColor] = ColorManager.blue
            eventCntString = NSAttributedString(
                string: "+\(amount.formattedWithComma())",
                attributes: eventCntAttributes
            )
        }
        else {
            eventCntAttributes[.foregroundColor] = ColorManager.red
            let absAmount = abs(amount)
            eventCntString = NSAttributedString(
                string: "-\(absAmount.formattedWithComma())",
                attributes: eventCntAttributes
            )
        }
        
        var suffixAttributes = AttributedFontManager.Caption
        suffixAttributes[.foregroundColor] = ColorManager.text01 ?? .black
        let suffixString = NSAttributedString(
            string: "원",
            attributes: suffixAttributes
        )

        attributedString.append(eventCntString)
        attributedString.append(suffixString)
        amountLabel.attributedText = attributedString
    }
}

