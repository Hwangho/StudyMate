//
//  ChatViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import NMapsMap


final class ChatViewModel {
    
    enum Action {
        
    }
    
    enum Mutation {
       
    }
    
    struct Store {
    
    }
    
    
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    let service: ChatServiceProtocool
    
    
    init(store: Store = Store(), serive: ChatServiceProtocool = ChatService() ) {
        self.store = store
        self.service = serive
        
        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
       
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        switch muation {

        }
        return .just(store)
    }
    
}
