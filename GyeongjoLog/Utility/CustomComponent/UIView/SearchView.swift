//import UIKit
//import SnapKit
//
//class SearchView: UIView {
//    let backView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 24*ConstantsManager.standardHeight
//        view.backgroundColor = ColorManager.bgGray
//        return view
//    }()
//    let searchImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = ImageManager.icon_search
//        return imageView
//    }()
//    let searchTextField: UITextField = {
//        let textField = UITextField()
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .font: FontManager.SubHead02_Medium,
//            .foregroundColor: UIColor.black 
//        ]
//        textField.defaultTextAttributes = textAttributes
//        let placeholderText = "Enter search text"
//        let placeholderAttributes: [NSAttributedString.Key: Any] = [
//            .font: FontManager.T4_15, // 원하는 폰트 설정
//            .foregroundColor: UIColor.gray // 플레이스홀더 텍스트 색상 설정
//        ]
//        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
//        
//        return textField
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        layout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func layout() {
//        addSubview(backView)
//        [searchImageView,searchTextField,clearButton]
//            .forEach{
//                searchView.addSubview($0)
//            }
//        
//        searchView.snp.makeConstraints { make in
//            make.width.equalTo(335*ConstantsManager.standardWidth)
//            make.height.equalTo(43*ConstantsManager.standardHeight)
//            make.center.equalToSuperview()
//        }
//        
//        searchImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(16.67*ConstantsManager.standardHeight)
//            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
//            make.centerY.equalToSuperview()
//        }
//        
//        searchTextField.snp.makeConstraints { make in
//            make.leading.equalTo(searchImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
//            make.trailing.equalToSuperview().offset(-12*ConstantsManager.standardWidth)
//            make.centerY.equalToSuperview()
//        }
//        
//        clearButton.snp.makeConstraints { make in
//            make.width.height.equalTo(20*ConstantsManager.standardHeight)
//            make.trailing.equalTo(searchTextField.snp.trailing)
//            make.centerY.equalTo(searchTextField)
//        }
//    }
//}
