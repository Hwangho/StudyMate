//
//  EmailViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import UIKit

import RxSwift
import RxRelay


final class EmailViewModel {
    
    enum Action {
        case inputEmail(String)
    }
    
    enum Mutation {
        case setEmail(String)
        case setEmailValid(Bool)
    }
    
    struct Store {
        var email: String?
        
        var checEmailValid = false
        
    }
    
    
    /// Properties
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    
    /// initialization
    init(store: Store = Store()) {
        self.store = store
        
        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    
    /// mutate, action
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .inputEmail(let text):
            
            
            
            return .concat([
                .just(.setEmail(text)),
                .just(.setEmailValid(text.isvalidEmail))
            ])
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setEmail(let email):
            store.email = email
        case .setEmailValid(let value):
            store.checEmailValid = value
        }
        return .just(store)
    }
}



