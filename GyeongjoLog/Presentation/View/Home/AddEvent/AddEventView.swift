import UIKit
import SnapKit

class AddEventView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nameView = SetEventDetailNameTextFieldView()
    let phoneNumberView = SetEventDetailTextFieldView(frame: .zero, titleText: "전화번호")
    let eventTypeView = SetEventDetailButtonView(frame: .zero, titleText: "이벤트")
    let dateView = SetEventDetailButtonView(frame: .zero, titleText: "날짜")
    let relationshipView = SetEventDetailButtonView(frame: .zero, titleText: "관계")
    let amountView = SetEventDetailTextFieldView(frame: .zero, titleText: "금액")
    let amountCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10*ConstantsManager.standardHeight
        layout.minimumLineSpacing = 6*ConstantsManager.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventAmountCollectionViewCell.self, forCellWithReuseIdentifier: "EventAmountCollectionViewCell")
        return collectionView
    }()
    let memoLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString()

        var eventCntAttributes = AttributedFontManager.Body0201
        eventCntAttributes[.foregroundColor] = ColorManager.text03 ?? .gray
        let eventCntString = NSAttributedString(
            string: "메모",
            attributes: eventCntAttributes
        )

        var suffixAttributes = AttributedFontManager.Caption
        suffixAttributes[.foregroundColor] = ColorManager.textDisabled ?? .gray
        let suffixString = NSAttributedString(
            string: "(선택)",
            attributes: suffixAttributes
        )

        attributedString.append(eventCntString)
        attributedString.append(suffixString)
        label.attributedText = attributedString
        return label
    }()
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.typingAttributes = AttributedFontManager.Body0201
        textView.textColor = ColorManager.text01
        textView.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 12*ConstantsManager.standardHeight
        textView.addPadding(width: 16*ConstantsManager.standardWidth, height: 16*ConstantsManager.standardHeight)
        return textView
    }()
    let addEventButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("추가하기", for: .normal)
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [nameView,phoneNumberView,eventTypeView,dateView,relationshipView,amountView,amountCollectionView,memoLabel,memoTextView,addEventButton]
            .forEach{
                contentView.addSubview($0)
            }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nameView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(28*ConstantsManager.standardHeight)
        }
        
        phoneNumberView.snp.makeConstraints { make in
            make.height.equalTo(33*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(nameView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
        eventTypeView.snp.makeConstraints { make in
            make.height.equalTo(33*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(phoneNumberView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
        dateView.snp.makeConstraints { make in
            make.height.equalTo(33*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(eventTypeView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
        relationshipView.snp.makeConstraints { make in
            make.height.equalTo(33*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(dateView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
        amountView.snp.makeConstraints { make in
            make.height.equalTo(33*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(relationshipView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
//        amountCollectionView.snp.makeConstraints { make in
//            make.width.equalTo(268*ConstantsManager.standardWidth)
//            make.height.equalTo(0)
//            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
//            make.top.equalTo(amountTextField.snp.bottom).offset(12*ConstantsManager.standardHeight)
//        }
        
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(amountView.snp.bottom).offset(32*ConstantsManager.standardHeight)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.width.equalTo(268*ConstantsManager.standardWidth)
            make.height.greaterThanOrEqualTo(148*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(memoLabel.snp.top)
        }
        
        addEventButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(memoTextView.snp.bottom).offset(30*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-25*ConstantsManager.standardHeight)
        }
    }
}
