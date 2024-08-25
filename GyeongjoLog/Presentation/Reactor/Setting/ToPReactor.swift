import ReactorKit
import RxCocoa
import RxFlow

class ToPReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var toP: String = """
1. 개인정보의 수집 및 이용 목적

    · 경조사 관리 서비스 제공: 사용자 간 경조사 비용의 기록 및 관리.
    · 통계 및 분석 제공: 경조사 비용에 대한 통계 및 분석 서비스 제공.

2. 수집하는 개인정보의 항목

    · 필수 정보: 이름, 전화번호, 이메일 주소, 경조사 기록(이름, 날짜, 금액 등).
    · 선택 정보: 사용자의 메모 또는 기타 부가 정보.

3. 개인정보의 보유 및 이용 기간

    경조로그는 개인정보의 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관련 법령에 따라 보존할 필요가 있는 경우, 법정 보존 기간 동안 보관합니다.

4. 개인정보의 제3자 제공

    경조로그는 사용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 사용자의 동의가 있거나 법령에 따라 필요한 경우에는 예외로 합니다.

5. 개인정보 보호를 위한 조치

    · 개인정보의 암호화
    · 해킹이나 바이러스에 대한 방지 조치
    · 개인정보 접근 제한

6. 개인정보 처리방침의 변경

    경조로그는 개인정보 처리방침의 변경이 있을 경우, 앱 내 공지사항 또는 이메일을 통해 사전에 고지합니다.

7. 개인정보 보호책임자
    사용자의 개인정보 관련 문의 사항은 아래의 연락처로 문의해 주시기 바랍니다:
    · 이메일: [1997pjs@naver.com]
    · 전화번호: [010-6631-2075]
"""
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}

