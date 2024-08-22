import UIKit
import SnapKit
import FSCalendar

class CalendarView: UIView {
    let yearMonthButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.text01, for: .normal)
        button.setTitleColor(ColorManager.text01?.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = FontManager.Heading02
        return button
    }()
    let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.calendar_left, for: .normal)
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.calendar_right, for: .normal)
        return button
    }()
    let allAmountButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.titleLabel?.font = FontManager.Body0101
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let receivedAmountButton: UIButton = {
        let button = UIButton()
        button.setTitle("받은 금액", for: .normal)
        button.titleLabel?.font = FontManager.Body0101
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let spentAmountButton: UIButton = {
        let button = UIButton()
        button.setTitle("보낸 금액", for: .normal)
        button.titleLabel?.font = FontManager.Body0101
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        calendar.allowsMultipleSelection = false
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = ColorManager.textDisabled
        calendar.appearance.weekdayFont = FontManager.Body02
        calendar.appearance.titleFont = FontManager.Body02
        calendar.appearance.subtitleFont = FontManager.Caption02
        calendar.appearance.weekdayTextColor = ColorManager.textDisabled
        calendar.appearance.titleDefaultColor = ColorManager.textDisabled
        calendar.appearance.subtitleDefaultColor = ColorManager.text01
        calendar.appearance.subtitleSelectionColor = ColorManager.text01
        calendar.appearance.eventSelectionColor = ColorManager.blue
        return calendar
    }()
    let selectDateInCalendarView = SelectDateInCalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [leftButton,yearMonthButton,rightButton,allAmountButton,receivedAmountButton,spentAmountButton,calendar,selectDateInCalendarView]
            .forEach{
                addSubview($0)
            }
        
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(28*ConstantsManager.standardWidth)
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(10*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        yearMonthButton.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalTo(leftButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(28*ConstantsManager.standardWidth)
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalTo(yearMonthButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        allAmountButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(yearMonthButton.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
        
        receivedAmountButton.snp.makeConstraints { make in
            make.leading.equalTo(allAmountButton.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.top.equalTo(yearMonthButton.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
        
        spentAmountButton.snp.makeConstraints { make in
            make.leading.equalTo(receivedAmountButton.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.top.equalTo(yearMonthButton.snp.bottom).offset(20*ConstantsManager.standardHeight)
        }
        
        calendar.snp.makeConstraints { make in
            make.height.equalTo(294*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(allAmountButton.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        selectDateInCalendarView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(calendar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func updateButtonStates(for type: AmountFilterType) {
        let buttons = [
            AmountFilterType.all: allAmountButton,
            AmountFilterType.received: receivedAmountButton,
            AmountFilterType.spent: spentAmountButton
        ]
        
        for (filterType, button) in buttons {
            updateButtonAppearance(button: button, isSelected: filterType == type)
        }
    }
    
    private func updateButtonAppearance(button: UIButton, isSelected: Bool) {
        if isSelected {
            button.setTitleColor(ColorManager.blue, for: .normal)
            button.backgroundColor = ColorManager.lightBlue
            button.layer.borderColor = ColorManager.blue?.cgColor
        } else {
            button.setTitleColor(ColorManager.text01, for: .normal)
            button.backgroundColor = ColorManager.white
            button.layer.borderColor = ColorManager.lightGrayFrame?.cgColor
        }
    }
}
