import RxFlow
import RxCocoa

enum PhraseStep: Step {
    // 푸시
    case navigateToPhraseViewController
    // 뒤로가기
    case popViewController
}
