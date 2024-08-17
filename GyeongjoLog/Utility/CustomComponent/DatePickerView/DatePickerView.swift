import UIKit

class DatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    private let pickerView = UIPickerView()
    
    private var years: [Int] = []
    private var months: [Int] = Array(1...12)
    private var days: [Int] = Array(1...31)
    
    var selectedYear: Int = Calendar.current.component(.year, from: Date()) {
        didSet {
            updateDays()
        }
    }
    var selectedMonth: Int = Calendar.current.component(.month, from: Date()) {
        didSet {
            updateDays()
        }
    }
    var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupYears()
        setupPickerView()
        selectCurrentDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupYears() {
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array((currentYear - 100)...(currentYear + 100))
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateDays() {
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            days = Array(range)
        } else {
            days = Array(1...31)
        }
        pickerView.reloadComponent(2) // 일 컴포넌트만 업데이트
    }
    
    func selectCurrentDate() {
        if let yearIndex = years.firstIndex(of: selectedYear) {
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: false)
        pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: false)
    }
    
    func getSelectedDateString() -> String {
        return String(format: "%04d.%02d.%02d", selectedYear, selectedMonth, selectedDay)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // 연, 월, 일
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        case 2:
            return days.count
        default:
            return 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(years[row])년"
        case 1:
            return "\(months[row])월"
        case 2:
            return "\(days[row])일"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedYear = years[row]
        case 1:
            selectedMonth = months[row]
        case 2:
            selectedDay = days[row]
        default:
            break
        }
    }
}
