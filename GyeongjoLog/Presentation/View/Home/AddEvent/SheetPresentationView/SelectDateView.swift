import UIKit
import SnapKit

class SelectDateView: UIView {
    let selectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜 선택"
        label.font = FontManager.SubHead04_SemiBold
        label.textColor = ColorManager.text01
        return label
    }()
    let dismisButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_x, for: .normal)
        return button
    }()
    let datePickerView = DatePickerView()
    let selectDateButton: BottomButton = {
        let button = BottomButton()
        button.setButtonTitle("선택하기")
        button.isEnable()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [selectDateLabel,dismisButton,datePickerView,selectDateButton]
            .forEach{
                addSubview($0)
            }
        
        selectDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        dismisButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(selectDateLabel)
        }
        
        datePickerView.snp.makeConstraints { make in
            make.height.equalTo(216*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(selectDateLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        selectDateButton.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
