//
//  CardDetailCollectionViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//


import RxSwift
import RxRelay


final class CardDetailCollectionViewModel {
    
    
    enum Action {
        case sendUserData(QueueUser)
    }
    
    enum Mutation {
        case setUserData(QueueUser)
    }
    
    struct Store {
        var user: QueueUser?
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
        case .sendUserData(let user):
            return .just(.setUserData(user))
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setUserData(let user):
            store.user = user
        }
        return .just(store)
    }
}

