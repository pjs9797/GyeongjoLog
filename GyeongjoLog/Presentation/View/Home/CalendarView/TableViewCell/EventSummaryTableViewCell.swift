import UIKit
import SnapKit

class EventSummaryTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
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
        [titleLabel,amountLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with event: Event) {
        let bulletText = "‧ "
        let nameText = "\(event.name)"
        let typeText = "님의 \(event.eventType)"
        
        let bulletAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body02,
            .foregroundColor: ColorManager.blue ?? .blue
        ]
        
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body02,
            .foregroundColor: ColorManager.text01 ?? .black
        ]
        
        let typeAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body0101,
            .foregroundColor: ColorManager.text03 ?? .gray
        ]
        
        let titleAttributedString = NSMutableAttributedString(string: bulletText, attributes: bulletAttributes)
        titleAttributedString.append(NSAttributedString(string: nameText, attributes: nameAttributes))
        titleAttributedString.append(NSAttributedString(string: typeText, attributes: typeAttributes))
        
        titleLabel.attributedText = titleAttributedString
        let absAmount = abs(event.amount)
        var amountText: String
        if event.amount > 0 {
            amountText = "+\(absAmount.formattedWithComma())"
        }
        else {
            amountText = "-\(absAmount.formattedWithComma())"
        }
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
