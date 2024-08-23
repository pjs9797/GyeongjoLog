import UIKit
import SnapKit

class SearchView: UIView {
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_search
        return imageView
    }()
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.SubHead02_Medium
        textField.textColor = ColorManager.text01
        
        let placeholderText = "이름 및 전화번호로 검색하세요."
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.SubHead02_Medium,
            .foregroundColor: ColorManager.text02 ?? .gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 24*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [searchImageView, searchTextField]
            .forEach{
                addSubview($0)
            }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(24*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview().offset(-1*ConstantsManager.standardHeight)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(14*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-24*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
}
