import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class AddEventReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let eventUseCase: EventUseCase
    var eventTypeRelay = PublishRelay<String>()
    var eventDateRelay = PublishRelay<String>()
    var eventRelationshipRelay = PublishRelay<String>()
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    enum Action {
        // 네비게이션 버튼, 하단 버튼 탭
        case backButtonTapped
        case deleteButtonTapped
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
        case setAmountText(String)
        
        // 추가 버튼 상태 설정
        case setIsEnableAddEventButton
    }
    
    struct State {
        // isEditing 상태
        var isEditingSetNameView: Bool = false
        var isEditingPhoneNumberView: Bool = false
        var isEditingEventTypeView: Bool = false
        var isEditingDateView: Bool = false
        var isEditingRelationshipView: Bool = false
        var isEditingAmountView: Bool = false
        
        // textField 텍스트 상태
        var name: String = ""
        var phoneNumber: String = ""
        var eventType: String = ""
        var date: String = ""
        var relationship: String = ""
        var amount: String = ""
        
        // 추가 버튼 상태
        var isEnableAddEventButton: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 네비게이션 버튼, 하단 버튼 탭
        case .backButtonTapped:
            self.steps.accept(EventHistoryStep.popViewController)
            return .empty()
        case .deleteButtonTapped:
            return .empty()
        case .addEventButtonTapped:
            guard let amount = Double(currentState.amount) else {
                // amount 변환 실패 시 처리
                return .empty()
            }
            let event = Event(id: UUID().uuidString,
                              name: currentState.name,
                              phoneNumber: currentState.phoneNumber,
                              eventType: currentState.eventType,
                              date: currentState.date,
                              relationship: currentState.relationship,
                              amount: amount,
                              memo: nil) // memo 처리 필요 시 추가
            self.steps.accept(EventHistoryStep.popViewController)
            return RealmManager.shared.saveRandomEvents()
                    .andThen(Completable.create { completable in
                        self.steps.accept(EventHistoryStep.popViewController)
                        completable(.completed)
                        return Disposables.create()
                    })
                    .andThen(.empty())
//            return eventUseCase.saveEvent(event: event)
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
            ])
        case .inputNameText(let name):
            return .concat([
                .just(.setNameText(name)),
                .just(.setIsEnableAddEventButton)
            ])
        case .nameViewClearButtonTapped:
            return .just(.setNameText(""))
            
            // 전화번호 뷰
        case .phoneNumberViewTapped:
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(true)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
            ])
        case .inputPhoneNumberText(let phoneNumber):
            let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
            return .concat([
                .just(.setPhoneNumberText(formattedPhoneNumber)),
                .just(.setIsEnableAddEventButton)
            ])
        case .phoneNumberViewClearButtonTapped:
            return .just(.setPhoneNumberText(""))
            
            // 이벤트 타입 뷰
        case .eventTypeViewTapped:
            self.steps.accept(EventHistoryStep.presentToSelectEventTypeViewController(eventTypeRelay: self.eventTypeRelay))
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(true)),
                .just(.setEditingDateView(false)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
            ])
        case .inputEventTypeTitle(let eventType):
            return .concat([
                .just(.setEventTypeTitle(eventType)),
                .just(.setIsEnableAddEventButton)
            ])
            
            // 날짜 뷰
        case .dateViewTapped:
            self.steps.accept(EventHistoryStep.presentToSelectDateViewController(eventDateRelay: eventDateRelay))
            return .concat([
                .just(.setEditingSetNameView(false)),
                .just(.setEditingPhoneNumberView(false)),
                .just(.setEditingEventTypeView(false)),
                .just(.setEditingDateView(true)),
                .just(.setEditingRelationshipView(false)),
                .just(.setEditingAmountView(false)),
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
            ])
        case .inputAmountText(let amount):
            return .concat([
                .just(.setAmountText(amount)),
                .just(.setIsEnableAddEventButton)
            ])
        case .amountViewClearButtonTapped:
            return .just(.setAmountText(""))
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
        case .setAmountText(let amount):
            newState.amount = amount
            
            // 추가 버튼
        case .setIsEnableAddEventButton:
            newState.isEnableAddEventButton = !newState.name.isEmpty &&
            !newState.phoneNumber.isEmpty &&
            !newState.eventType.isEmpty &&
            !newState.date.isEmpty &&
            !newState.relationship.isEmpty &&
            !newState.amount.isEmpty
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
