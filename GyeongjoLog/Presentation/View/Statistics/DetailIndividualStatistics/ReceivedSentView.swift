import UIKit
import SnapKit

class ReceivedSentView: UIView {
    let receivedLabel: UILabel = {
        let label = UILabel()
        label.text = "받음"
        label.font = FontManager.Body0101
        label.textColor = ColorManager.text03
        return label
    }()
    let sentLabel: UILabel = {
        let label = UILabel()
        label.text = "보냄"
        label.font = FontManager.Body0101
        label.textColor = ColorManager.text03
        return label
    }()
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let receivedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.SubHead03_SemiBold
        label.textColor = ColorManager.blue
        return label
    }()
    let sentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.SubHead03_SemiBold
        label.textColor = ColorManager.red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.bgGray
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [separateView,receivedLabel,receivedAmountLabel,sentLabel,sentAmountLabel]
            .forEach{
                addSubview($0)
            }
        
        separateView.snp.makeConstraints { make in
            make.width.equalTo(1*ConstantsManager.standardWidth)
            make.height.equalTo(42*ConstantsManager.standardHeight)
            make.center.equalToSuperview()
        }
        
        receivedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(74*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(18*ConstantsManager.standardHeight)
        }
        
        receivedAmountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(receivedLabel)
            make.bottom.equalToSuperview().offset(-22*ConstantsManager.standardHeight)
        }
        
        sentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-74*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(18*ConstantsManager.standardHeight)
        }
        
        sentAmountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(sentLabel)
            make.bottom.equalToSuperview().offset(-22*ConstantsManager.standardHeight)
        }
    }
}
