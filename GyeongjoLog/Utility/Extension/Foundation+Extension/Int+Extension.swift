import Foundation

extension Int {
    // 천 단위 컴마 추가
    func formattedWithComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
