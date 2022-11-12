//
//  NickNameViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import RxSwift
import RxRelay


class NickNameViewModel {
    
    enum Action {
        case inputText(String)
    }
    
    enum Mutation {
        case setNickName(String)
        case setTextValid(Bool)
    }
    
    struct Store {
        var nickName: String?
        var checkNickNameValid = false
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
        case .inputText(let text):
            var text = text
            if text.count > 11 {
                let index = text.index(text.startIndex, offsetBy: 11)
                text = String(text[..<index])
            }
            
            let valid =  text.count >= 2 && text.count <= 10 ? true : false
            
            return .concat([
                Observable.just(.setNickName(text)),
                Observable.just(.setTextValid(valid))
            ])
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setNickName(let text):
            store.nickName = text
            
        case .setTextValid(let value):
            store.checkNickNameValid = value
            
        }
        return .just(store)
    }
}



