import UIKit
import SnapKit

class SortView: UIView {
    let firstSortButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(ColorManager.blue, for: .normal)
        button.setTitleColor(ColorManager.blue?.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = FontManager.Body0201
        return button
    }()
    let secondSortButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(ColorManager.black, for: .normal)
        button.setTitleColor(ColorManager.black?.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = FontManager.Body0201
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.white?.withAlphaComponent(0.95)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [firstSortButton,secondSortButton]
            .forEach{
                addSubview($0)
            }
        
        firstSortButton.snp.makeConstraints { make in
            make.width.equalTo(140*ConstantsManager.standardWidth)
            make.height.equalTo(65*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        firstSortButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(24*ConstantsManager.standardHeight)
        }
        
        secondSortButton.snp.makeConstraints { make in
            make.width.equalTo(140*ConstantsManager.standardWidth)
            make.height.equalTo(65*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(firstSortButton.snp.bottom)
        }
        
        secondSortButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(24*ConstantsManager.standardHeight)
        }
    }
    
    func setSortViewButton(title: String){
        if title == "최신순"{
            self.firstSortButton.setTitleColor(ColorManager.blue, for: .normal)
            self.secondSortButton.setTitleColor(ColorManager.black, for: .normal)
        }
        else {
            self.firstSortButton.setTitleColor(ColorManager.black, for: .normal)
            self.secondSortButton.setTitleColor(ColorManager.blue, for: .normal)
        }
    }
}
