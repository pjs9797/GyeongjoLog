import UIKit
import SnapKit

class TapBarCollectionView: UICollectionView {
    
    private let underlineView = UIView()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        basicSetup()
        setStyle()
        setLayout()
    }
    
    private func basicSetup() {
        self.backgroundColor = .white
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
    }

    private func setStyle() {
        underlineView.backgroundColor = .blue // 밑줄 색상을 설정
    }

    private func setLayout() {
        self.addSubview(underlineView)
        
        // 밑줄 초기 설정
        underlineView.snp.makeConstraints {
            $0.width.equalTo(50) // 초기 너비를 설정합니다.
            $0.height.equalTo(3)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(15) // 초기 위치를 설정합니다.
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveUnderlineFor(at tappedRect: TapRect) {
        underlineView.snp.remakeConstraints {
            $0.width.equalTo(tappedRect.width)
            $0.height.equalTo(3)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(tappedRect.xPosition.x)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // 레이아웃 변경 사항을 화면에 반영
        }
    }
}


extension UICollectionView {
    func fetchCellRectFor(indexPath index: IndexPath, paddingFromLeading: CGFloat, cellHorizontalPadding: CGFloat) -> TapRect {
        guard let cellAttributes = self.layoutAttributesForItem(at: index) else {
            return TapRect(index: 0, width: 0, xPosition: CGPoint())
        }
        
        let cellOrigin = cellAttributes.frame.origin
        let cellXPosition = CGPoint(x: cellOrigin.x + paddingFromLeading, y: cellOrigin.y)
        let cellWidth = cellAttributes.size.width - cellHorizontalPadding
        
        return TapRect(index: index.item, width: cellWidth, xPosition: cellXPosition)
    }
}

struct TapRect {
    var index: Int
    var width: CGFloat
    var xPosition: CGPoint
}
