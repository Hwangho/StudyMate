//
//  OnBoardingViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import RxSwift
import RxRelay


class CertificationViewModel {
    
    enum Action {
        case inputText(String)
    }
    
    enum Mutation {
        case setText(String)
        case setTextValid(Bool)
    }
    
    struct Store {
        var phoneNumber: String?
        var checkNumberValid: Bool = false
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
            
            let valid =  text.count >= 10 && text.count <= 11 && text.starts(with: "01") ? true : false
            
            return .concat([
                Observable.just(.setText(text)),
                Observable.just(.setTextValid(valid))
            ])
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setText(let text):
            store.phoneNumber = text
            
        case .setTextValid(let value):
            store.checkNumberValid = value
        }
        return .just(store)
    }
    
}


