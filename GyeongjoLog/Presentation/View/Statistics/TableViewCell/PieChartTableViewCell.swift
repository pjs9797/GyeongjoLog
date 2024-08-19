import UIKit
import SnapKit

class PieChartTableViewCell: UITableViewCell {
    let colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4*ConstantsManager.standardHeight
        return imageView
    }()
    let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body0201
        label.textColor = ColorManager.text01
        return label
    }()
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text03
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [colorImageView,eventTypeLabel,percentLabel,amountLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        colorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        eventTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorImageView.snp.trailing).offset(12*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(eventTypeLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with detail: PieChartDetail) {
        let eventType = detail.eventType
        
        if let colorName = UserDefaultsManager.shared.fetchColor(forEventType: eventType),
           let color = UIColor(named: colorName) {
            colorImageView.backgroundColor = color
        } 
        else {
            colorImageView.backgroundColor = ColorManager.blue
        }
        
        eventTypeLabel.text = eventType
        percentLabel.text = "(\(detail.percentage)%)"
        
        var amountText = detail.amount.formattedWithComma()
        let currencyText = "원"
        
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body02,
            .foregroundColor: ColorManager.text01 ?? .black
        ]
        
        let currencyAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Caption,
            .foregroundColor: ColorManager.text01 ?? .black
        ]
        
        let amountAttributedString = NSMutableAttributedString(string: amountText, attributes: amountAttributes)
        amountAttributedString.append(NSAttributedString(string: currencyText, attributes: currencyAttributes))
        
        amountLabel.attributedText = amountAttributedString
    }
}
