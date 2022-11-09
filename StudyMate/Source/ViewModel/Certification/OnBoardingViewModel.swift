//
//  OnBoardingViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import RxSwift
import RxRelay


class OnBoardingViewModel {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct Store {
        
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
        

    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        
        
        return .just(store)
    }
    
}