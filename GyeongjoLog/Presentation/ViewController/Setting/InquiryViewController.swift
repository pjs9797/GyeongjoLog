import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import MessageUI

class InquiryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_back, style: .plain, target: nil, action: nil)
    let inquiryView = InquiryView()
    
    init(with reactor: InquiryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = inquiryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "문의하기"
        navigationItem.leftBarButtonItem = backButton
    }
}

extension InquiryViewController {
    func bind(reactor: InquiryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: InquiryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inquiryView.sendEmailButton.rx.tap
            .bind(onNext: { [weak self] _ in
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    
                    let bodyString = """
                                         이곳에 내용을 작성해 주세요.
                                         
                                         
                                         ================================
                                         Device Model : \(UIDevice.current.modelName)
                                         Device OS : \(UIDevice.current.systemVersion)
                                         App Version : \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "1.0")
                                         ================================
                                         """
                    
                    // 받는 사람 이메일, 제목, 본문
                    composeVC.setToRecipients(["1997pjs@naver.com"])
                    composeVC.setSubject("문의 사항")
                    composeVC.setMessageBody(bodyString, isHTML: false)
                    
                    self?.present(composeVC, animated: true)
                } else {
                    // 만약, 디바이스에 email 기능이 비활성화 일 때, 사용자에게 알림
                    let alertController = UIAlertController(title: "메일 계정 활성화 필요",
                                                            message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.",
                                                            preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                        guard let mailSettingsURL = URL(string: "mailto:") else { return }
                        
                        if UIApplication.shared.canOpenURL(mailSettingsURL) {
                            UIApplication.shared.open(mailSettingsURL, options: [:], completionHandler: nil)
                        }
                    }
                    alertController.addAction(alertAction)
                    
                    self?.present(alertController, animated: true)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: InquiryReactor){
    }
}

extension InquiryViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("메일 보내기 성공")
        case .cancelled:
            print("메일 보내기 취소")
        case .saved:
            print("메일 임시 저장")
        case .failed:
            print("메일 발송 실패")
        @unknown default: break
        }
        
        self.dismiss(animated: true)
    }
}
