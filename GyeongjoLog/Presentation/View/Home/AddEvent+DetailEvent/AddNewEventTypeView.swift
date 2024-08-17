import UIKit
import SnapKit

class AddNewEventTypeView: UIView {
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.lightGrayFrame
        return view
    }()
    let eventNameTextField : UITextField = {
        let textField = UITextField()
        textField.font = FontManager.Body04
        textField.textColor = ColorManager.black
        
        let placeholderText = "이벤트 이름"
        var placeholderAttributes = AttributedFontManager.Body04
        placeholderAttributes[.foregroundColor] = ColorManager.textDisabled ?? .gray
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_delete, for: .normal)
        return button
    }()
    let nameLengthLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Caption01
        label.textColor = ColorManager.text03
        return label
    }()
    let selectColorLabel: UILabel = {
        let label = UILabel()
        label.text = "지정 색상"
        label.font = FontManager.Body0201
        label.textColor = ColorManager.black
        return label
    }()
    let selectColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 22*ConstantsManager.standardWidth
        layout.minimumLineSpacing = 20*ConstantsManager.standardHeight
        layout.itemSize = CGSize(width: 30*ConstantsManager.standardHeight, height: 30*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SelectColorCollectionViewCell.self, forCellWithReuseIdentifier: "SelectColorCollectionViewCell")
        return collectionView
    }()
    let addEventTypeButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("적용하기", for: .normal)
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
        [bottomBorderView,clearButton,eventNameTextField,nameLengthLabel,selectColorLabel,selectColorCollectionView,addEventTypeButton]
            .forEach{
                addSubview($0)
            }
        
        bottomBorderView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(70*ConstantsManager.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.trailing.equalTo(bottomBorderView.snp.trailing)
            make.bottom.equalTo(bottomBorderView.snp.top).offset(-6*ConstantsManager.standardHeight)
        }
        
        eventNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(bottomBorderView.snp.leading)
            make.trailing.equalTo(clearButton.snp.leading).offset(5*ConstantsManager.standardWidth)
            make.centerY.equalTo(clearButton)
        }
        
        nameLengthLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bottomBorderView.snp.trailing)
            make.top.equalTo(bottomBorderView.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        selectColorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(bottomBorderView.snp.bottom).offset(64*ConstantsManager.standardHeight)
        }
        
        selectColorCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(selectColorLabel.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        addEventTypeButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-26*ConstantsManager.standardHeight)
        }
    }
}
