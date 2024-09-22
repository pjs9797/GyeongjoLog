import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class AddEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let eventUseCase: EventUseCase
    let eventLocalDBUseCase: EventLocalDBUseCase
    let addEventFlow: AddEventFlow
    var eventTypeRelay = PublishRelay<String>()
    var eventDateRelay = PublishRelay<String>()
    var eventRelationshipRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase, eventLocalDBUseCase: EventLocalDBUseCase, addEventFlow: AddEventFlow) {
        self.eventUseCase = eventUseCase
        self.eventLocalDBUseCase = eventLocalDBUseCase
        self.addEventFlow = addEventFlow
        self.initialState = State(
            eventAmounts: addEventFlow == .myEventSummary ? [10000, 50000, 100000, 500000, 1000000] : [-10000, -50000, -100000, -500000, -1000000]
        )
    }
    
    enum Action {
        // 네비게이션 버튼, 하단 버튼 탭
        case backButtonTapped
        case addEventButtonTapped
        
        // 이름 뷰
        case nameViewTapped
        case inputNameText(String)
        case nameViewClearButtonTapped
        
        // 전화번호 뷰
        case phoneNumberViewTapped
        case inputPhoneNumberText(String)
        case phoneNumberViewClearButtonTapped
        
        // 이벤트 타입 뷰
        case eventTypeViewTapped
        case inputEventTypeTitle(String)
        
        // 날짜 뷰
        case dateViewTapped
        case inputDateTitle(String)
        
        // 관계 뷰
        case relationshipViewTapped
        case inputRelationshipTitle(String)
        
        // 금액 뷰
        case amountViewTapped
        case inputAmountText(String)
        case amountViewClearButtonTapped
        
        // 금액 컬렉션뷰 셀 탭
        case selectAmount(Int)
        
        // 메모 뷰
        case memoTextViewTapped
        case inputMemoText(String)
    }
    
    enum Mutation {
        // 이름 뷰
        case setEditingSetNameView(Bool)
        case setNameText(String)
        
        // 전화번호 뷰
        case setEditingPhoneNumberView(Bool)
        case setPhoneNumberText(String)
        
        // 이벤트 타입 뷰
        case setEditingEventTypeView(Bool)
        case setEventTypeTitle(String)
        
        // 날짜 뷰
        case setEditingDateView(Bool)
        case setDateTitle(String)
        
        // 관계 뷰
        case setEditingRelationshipView(Bool)
        case setRelationshipTitle(String)
        
        // 금액 뷰
        case setEditingAmountView(Bool)
        case setAmount(Int)
        case setFormattedAmountText(NSAttributedString?)
        
        // 금액 컬렉션뷰
        case addAmount(Int)
        
        // 추가 버튼 상태 설정
        case setIsEnableAddEventButton
        
        // 메모 뷰
        case setEditingMemoTextView(Bool)
        case setMemoText(String)
    }
    
    struct State {
        // isEditing 상태
        var isEditingSetNameView: Bool = false
        var isEditingPhoneNumberView: Bool = false
        var isEditingEventTypeView: Bool = false
        var isEditingDateView: Bool = false
        var isEditingRelationshipView: Bool = false
        var isEditingAmountView: Bool = false
        var isEditingMemoTextView: Bool = false
        
        // textField 텍스트 상태
        var name: String = ""
        var phoneNumber: String = ""
        var eventType: String = ""
        var date: String = ""
        var relationship: String = ""
        var amount: Int = 0
        var formattedAmount: NSAttributedString?
        var memo: String?
        
        var eventAmounts: [Int]
        
        // 추가 버튼 상태
        var isEnableAddEventButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 네비게이션 버튼, 하단 버튼 탭
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
        case .addEventButtonTapped:
            let event = Event(id: UUID().uuidString,
                              name: currentState.name,
                              phoneNumber: currentState.phoneNumber,
                              eventType: currentState.eventType,
                              date: currentState.date,
                              relationship: currentState.relationship,
                              amount: currentState.amount,
                              memo: currentState.memo)
            if UserDefaultsManager.shared.isLoggedIn() {
                return self.eventUseCase.addEvent(event: event)
                    .flatMap { [weak self] _ -> Observable<Mutation> in
                        self?.steps.accept(EventHistoryStep.popViewController)
                        return .empty()
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error: error) { (step: EventHistoryStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
            else {
                return self.eventLocalDBUseCase.saveEvent(event: event)
                    .andThen(Completable.create { completable in
                        self.steps.accept(EventHistoryStep.popViewController)
                        completable(.completed)
                        return Disposables.create()
                    })
                    .andThen(.empty())
            }
//            return RealmManager.shared.saveRandomEvents()
//                .andThen(Completable.create { completable in
//                    self.steps.accept(EventHistoryStep.popViewController)
//                    completable(.completed)
//                    return Disposables.create()
//                })
//                .andThen(.empty())
            
            // 이름 뷰
        case .nameViewTapped:
            return .concat([
                .just(.setEditingSetNameView(true)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputNameText(let name):
            return .concat([
                .just(.setNameText(name)),
                .just(.setIsEnableAddEventButton)
            ])
        case .nameViewClearButtonTapped:
            return .concat([
                .just(.setNameText("")),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 전화번호 뷰
        case .phoneNumberViewTapped:
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(true)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputPhoneNumberText(let phoneNumber):
            let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
            return .concat([
                .just(.setPhoneNumberText(formattedPhoneNumber)),
                .just(.setIsEnableAddEventButton)
            ])
        case .phoneNumberViewClearButtonTapped:
            return .concat([
                .just(.setPhoneNumberText("")),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 이벤트 타입 뷰
        case .eventTypeViewTapped:
            let currentEventType = currentState.eventType.isEmpty ? nil : currentState.eventType
            self.steps.accept(EventHistoryStep.presentToSelectEventTypeViewController(eventTypeRelay: self.eventTypeRelay, initialEventType: currentEventType))
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(true)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputEventTypeTitle(let eventType):
            return .concat([
                .just(.setEventTypeTitle(eventType)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 날짜 뷰
        case .dateViewTapped:
            let currentDate = currentState.date.isEmpty ? nil : currentState.date
            self.steps.accept(EventHistoryStep.presentToSelectEventDateViewController(eventDateRelay: eventDateRelay, initialDate: currentDate))
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(true)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputDateTitle(let date):
            return .concat([
                .just(.setDateTitle(date)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 관계 뷰
        case .relationshipViewTapped:
            self.steps.accept(EventHistoryStep.presentToSelectRelationshipViewController(eventRelationshipRelay: eventRelationshipRelay))
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(true)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputRelationshipTitle(let relationship):
            return .concat([
                .just(.setRelationshipTitle(relationship)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 금액 뷰
        case .amountViewTapped:
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(true)),
                .just(.setEditingMemoTextView(false))
            ])
        case .inputAmountText(let text):
            let amountText = text.replacingOccurrences(of: "원", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "+", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespaces)
            
            let amountValue = Int(amountText) ?? 0
            let isOthersEvent = addEventFlow == .othersEventSummary
            let isMyEvent = addEventFlow == .myEventSummary
            
            let formattedText: NSAttributedString?
            if amountValue == 0 {
                formattedText = nil
            } else {
                let formattedAmountText = (isOthersEvent ? "- " : (isMyEvent ? "+ " : "")) + amountValue.formattedWithComma()
                let attributedText = NSMutableAttributedString(string: formattedAmountText, attributes: [
                    .font: FontManager.Heading0101
                ])
                let wonText = NSAttributedString(string: "원", attributes: [
                    .font: FontManager.Body02
                ])
                attributedText.append(wonText)
                formattedText = attributedText
            }
            
            return .concat([
                .just(.setAmount(isOthersEvent ? -amountValue : amountValue)),
                .just(.setFormattedAmountText(formattedText)),
                .just(.setIsEnableAddEventButton)
            ])
        case .amountViewClearButtonTapped:
            return .concat([
                .just(.setAmount(0)),
                .just(.setFormattedAmountText(nil)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 금액 컬렉션뷰
        case .selectAmount(let index):
            let selectedAmount = currentState.eventAmounts[index]
            return .concat([
                .just(.addAmount(selectedAmount)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 메모 뷰
        case .memoTextViewTapped:
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
                .just(.setEditingMemoTextView(true))
            ])
        case .inputMemoText(let text):
            return .just(.setMemoText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            // 이름 뷰
        case .setEditingSetNameView(let isEditing):
            newState.isEditingSetNameView = isEditing
        case .setNameText(let name):
            newState.name = name
            
            // 전화번호 뷰
        case .setEditingPhoneNumberView(let isEditing):
            newState.isEditingPhoneNumberView = isEditing
        case .setPhoneNumberText(let phoneNumber):
            newState.phoneNumber = phoneNumber
            
            // 이벤트 타입 뷰
        case .setEditingEventTypeView(let isEditing):
            newState.isEditingEventTypeView = isEditing
        case .setEventTypeTitle(let eventType):
            newState.eventType = eventType
            
            // 날짜 뷰
        case .setEditingDateView(let isEditing):
            newState.isEditingDateView = isEditing
        case .setDateTitle(let date):
            newState.date = date
            // 관계 뷰
        case .setEditingRelationshipView(let isEditing):
            newState.isEditingRelationshipView = isEditing
        case .setRelationshipTitle(let relationship):
            newState.relationship = relationship
            
            // 금액 뷰
        case .setEditingAmountView(let isEditing):
            newState.isEditingAmountView = isEditing
        case .setAmount(let amount):
            newState.amount = amount
        case .setFormattedAmountText(let formattedText):
            newState.formattedAmount = formattedText
            
            // 금액 컬렉션뷰
        case .addAmount(let amount):
            let currentAmount = currentState.amount
            let newAmount = currentAmount + amount
            newState.amount = newAmount
            let absAmount = abs(newAmount)
            let formattedAmountText = (addEventFlow == .othersEventSummary ? "- " : (addEventFlow == .myEventSummary ? "+ " : "")) + absAmount.formattedWithComma()
            let attributedText = NSMutableAttributedString(string: formattedAmountText, attributes: [
                .font: FontManager.Heading0101
            ])
            let wonText = NSAttributedString(string: "원", attributes: [
                .font: FontManager.Body02
            ])
            attributedText.append(wonText)
            newState.formattedAmount = attributedText
            
            // 메모 뷰
        case .setEditingMemoTextView(let isEditing):
            newState.isEditingMemoTextView = isEditing
        case .setMemoText(let text):
            newState.memo = text
            
            // 추가 버튼
        case .setIsEnableAddEventButton:
            newState.isEnableAddEventButton = !newState.name.isEmpty &&
            newState.phoneNumber.count == 13 &&
            !newState.eventType.isEmpty &&
            !newState.date.isEmpty &&
            !newState.relationship.isEmpty &&
            newState.amount != 0
        }
        return newState
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let digitsOnly = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var formattedString = ""
        for (index, character) in digitsOnly.enumerated() {
            if index == 3 || index == 7 {
                formattedString.append("-")
            }
            formattedString.append(character)
        }
        return String(formattedString.prefix(13))
    }
}
