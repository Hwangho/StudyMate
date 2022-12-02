//
//  WithDrawView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth


final class WithDrawView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let withDraButton = UIButton()
    
    private let service =  UserService()
    
    private let disposeBag = DisposeBag()
    
    weak var coordinator: ChangeMyPageCoordinator?

    private var viewModel: WithDrawViewModel
    
    var customAlertViewController = CustomAlertViewController()
    
    
    /// life Cycle
    init(viewModel: WithDrawViewModel = WithDrawViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "회원 탈퇴"
        
        withDraButton.setTitle("", for: .normal)
        withDraButton.backgroundColor = .clear
        
        withDraButton.addTarget(self, action: #selector(tapWithdrawButton), for: .touchUpInside)
        
        customAlertViewController.delegate = self
    }
    
    override func setupLayout() {
        [titleLabel, withDraButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        withDraButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func setupBinding() {
        
        viewModel.currentStore
            .distinctUntilChanged{ $0.statusCode }
            .map { $0.statusCode ?? .error }
            .bind {[weak self] statusType in
                switch statusType {
                case .fireBaseToken:
                    self?.fireBaseIDTokenRefresh {
                        self?.viewModel.action.accept(.tapWithDraw)
                    }
                case .alreadyWithdraw:
                    self?.coordinator?.showInitialView(with: .onBoarding)
                default:
                    print(statusType.message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    func tapWithdrawButton() {
        customAlertViewController.configure(alertTitleText: "정말 탈퇴하시곘습니까?", alertContentText: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ")
        customAlertViewController.modalPresentationStyle = .overFullScreen
        coordinator?.presenter.present(customAlertViewController, animated: true)
    }
    

}

extension WithDrawView: CustomAlertActionProtocool {
    func tapCancel() {
        coordinator?.presenter.dismiss(animated: true)
    }
    
    func tapConfirm() {
        viewModel.action.accept(.tapWithDraw)
    }
    
}





final class WithDrawViewModel {
    
    enum Action {
        case tapWithDraw
    }
    
    enum Mutation {
        case setWithDraw(WithDrawStatusCode)
        case withDrawSuccess(Bool)
    }
    
    struct Store {
        var statusCode: WithDrawStatusCode?
        var withDrawSuccess: Bool?
    }
    
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    var service: UserServiceProtocool
    
    
    init (store: Store = Store(), service: UserServiceProtocool = UserService()) {
        self.store = store
        self.service = service
        
        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    /// mutate, action
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .tapWithDraw:
            
            return service.withdraw()
                .asObservable()
                .map { response -> Mutation in
                    guard let statusCode = response?.statusCode else { return .withDrawSuccess(false) }
                    let type = WithDrawStatusCode(rawValue: statusCode)!
                    return .setWithDraw(type)
                }
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setWithDraw(let type):
            store.statusCode = type
            
        case .withDrawSuccess(let value):
            store.withDrawSuccess = value
        }
        
        return .just(store)
    }
}








enum WithDrawStatusCode: Int, Error {
    case fireBaseToken = 401
    case alreadyWithdraw = 406
    case serverError = 500
    case clientError = 501
    case error

    var message: String {
        switch self {
        case .fireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .alreadyWithdraw: return "이미 탈퇴 처리된 회원/미가입 회원"
        case .serverError: return ""
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
        case .error: return "error"
        default:
            return "error"
        
        }
    }
    
}
