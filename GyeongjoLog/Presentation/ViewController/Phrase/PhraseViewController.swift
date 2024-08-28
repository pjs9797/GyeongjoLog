import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class PhraseViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let logoImage = UIBarButtonItem(image: ImageManager.header3, style: .plain, target: nil, action: nil)
    let phraseView = PhraseView()
    
    init(with reactor: PhraseReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = phraseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.white
        self.setNavigationbar()
        self.phraseView.phraseCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = logoImage
    }
}

extension PhraseViewController {
    func bind(reactor: PhraseReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PhraseReactor){
        // 컬렉션 뷰 항목 선택
        phraseView.phraseCollectionView.rx.itemSelected
            .map { Reactor.Action.selectType($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 랜덤 버튼 클릭
        phraseView.randomButton.rx.tap
            .map { Reactor.Action.randomizePhrase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 복사 버튼 클릭
        phraseView.copyButton.rx.tap
            .do(onNext: { [weak self] in
                self?.phraseView.toastMessage.isHidden = false
                self?.phraseView.toastMessage.alpha = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.phraseView.toastMessage.isHidden = true
                }
//                UIView.animate(withDuration: 4.0, animations: {
//                    self?.phraseView.toastMessage.alpha = 0.0
//                }, completion: { _ in
//                    self?.phraseView.toastMessage.isHidden = true
//                })
            })
            .map { Reactor.Action.copyPhrase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PhraseReactor){
        reactor.state.map { $0.eventTypes }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: phraseView.phraseCollectionView.rx.items(cellIdentifier: "PhraseCollectionViewCell", cellType: PhraseCollectionViewCell.self)) { index, eventType, cell in

                cell.configure(with: eventType)
            }
            .disposed(by: disposeBag)
        
        // 텍스트뷰에 선택된 문구 표시
        reactor.state.map { $0.selectedPhrase }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                var attribute = AttributedFontManager.SubHead02_Medium
                attribute[.foregroundColor] = ColorManager.text01 ?? .black
                let attributedText = NSAttributedString(string: text, attributes: attribute)
                
                self?.phraseView.phrasetextView.attributedText = attributedText
            })
            .disposed(by: disposeBag)
    }
}
