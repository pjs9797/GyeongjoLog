import UIKit
import SnapKit

class PhraseView: UIView {
    let phraseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18*ConstantsManager.standardWidth
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhraseCollectionViewCell.self, forCellWithReuseIdentifier: "PhraseCollectionViewCell")
        return collectionView
    }()
    let randomButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_reset, for: .normal)
        return button
    }()
    let copyButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_copy, for: .normal)
        return button
    }()
    let phrasetextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = ColorManager.bgGray
        textView.layer.cornerRadius = 12*ConstantsManager.standardHeight
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 0, right: 22)
        textView.isEditable = false
        return textView
    }()
    let toastMessage = ToastMessage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = ColorManager.white
        self.toastMessage.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [phraseCollectionView,copyButton,randomButton,phrasetextView,toastMessage]
            .forEach{
                addSubview($0)
            }
        
        phraseCollectionView.snp.makeConstraints { make in
            make.height.equalTo(105*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30*ConstantsManager.standardHeight)
        }
        
        copyButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(phraseCollectionView.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        randomButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalTo(copyButton.snp.leading).offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(copyButton)
        }
        
        phrasetextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(copyButton.snp.bottom).offset(9*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-100*ConstantsManager.standardHeight)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.width.equalTo(196*ConstantsManager.standardWidth)
            make.height.equalTo(49*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
    }
}
