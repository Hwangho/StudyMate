//
//  SplachviewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import RxSwift
import RxRelay
import FirebaseAuth


final class SplachviewModel {
    
    
    enum Action {
        case login
    }
    
    enum Mutation {
        case setLogin(ServerWrapper)
    }
    
    struct Store {
        var serverType: ServerWrapper?
    }
    
    
    /// Properties
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    private var service: UserServiceProtocool
    
    
    /// initialization
    init(store: Store = Store(), service: UserServiceProtocool = UserService()) {
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
        case .login:
            return service.signin()
                .asObservable()
                .map{ response -> Mutation in
                    guard let statusCode = response?.statusCode else { return  .setLogin(.error) }
                    let type: ServerWrapper = ServerWrapper(rawValue: statusCode)!
                    return .setLogin(type)
                }
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setLogin(let type):
            store.serverType = type
        }
        return .just(store)
    }
}

