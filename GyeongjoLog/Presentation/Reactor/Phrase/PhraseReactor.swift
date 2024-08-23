import ReactorKit
import RxCocoa
import RxFlow
import UIKit

class PhraseReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case selectType(Int)
        case randomizePhrase
        case copyPhrase
    }
    
    enum Mutation {
        case setSelectedType(Int)
        case setSelectedPhrase(String)
        case randomizePhrase(String)
    }
    
    struct State {
        var eventTypes: [String] = ["결혼식","장례식","생일","돌잔치"]
        var phraseOne: [String] = PhraseManager.shared.fetchPhraseOne()
        var phraseTwo: [String] = PhraseManager.shared.fetchPhraseTwo()
        var phraseThree: [String] = PhraseManager.shared.fetchPhraseThree()
        var phraseFour: [String] = PhraseManager.shared.fetchPhraseFour()
        var selectedPhrase: String = "따뜻한 마음으로 보내주신 초대장에 감사드립니다. 두 분이 함께 걸어갈 새로운 여정에 축복을 보냅니다. 결혼이라는 아름다운 결실을 맺기까지의 모든 순간이 여러분에게 큰 의미가 있었으리라 믿습니다. 두 분의 결혼식이 사랑과 감동으로 가득한 날이 되기를 바랍니다."
        var selectedIndex: Int = 0
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectType(let index):
            var phrase: String = ""
            if index == 0 {
                phrase = currentState.phraseOne[0]
            }
            else if index == 1 {
                phrase = currentState.phraseTwo[0]
            }
            else if index == 2 {
                phrase = currentState.phraseThree[0]
            }
            else if index == 3 {
                phrase = currentState.phraseFour[0]
            }
            return .concat([
                .just(.setSelectedType(index)),
                .just(.setSelectedPhrase(phrase))
            ])
            
        case .randomizePhrase:
            var phrases: [String] = []
            if currentState.selectedIndex == 0 {
                phrases = currentState.phraseOne
            }
            else if currentState.selectedIndex == 1 {
                phrases = currentState.phraseTwo
            }
            else if currentState.selectedIndex == 2 {
                phrases = currentState.phraseThree
            }
            else if currentState.selectedIndex == 3 {
                phrases = currentState.phraseFour
            }
            var randomPhrase: String
            
            repeat {
                randomPhrase = phrases.randomElement() ?? ""
            } while randomPhrase == currentState.selectedPhrase
            
            return .just(.randomizePhrase(randomPhrase))
            
        case .copyPhrase:
            UIPasteboard.general.string = currentState.selectedPhrase
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedPhrase(let phrase):
            newState.selectedPhrase = phrase
        case .randomizePhrase(let phrase):
            newState.selectedPhrase = phrase
        case .setSelectedType(let index):
            newState.selectedIndex = index
        }
        return newState
    }
}

