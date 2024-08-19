import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.date(from: self)!
    }
    
    func toMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        
        let monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = "yyyy.M"
        return monthYearFormatter.string(from: date)
    }
}
