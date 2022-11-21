//
//  ChangeMyPageViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift


final class ChangeMyPageViewModel {
    
    enum Action {
        case myInfo
    }

    enum Mutation {
        case setUser(User)
        case setError(ServerWrapper?)
    }

    struct Store {
        var user: User?
        var errorType: ServerWrapper?
    }

    let action = PublishRelay<Action>()

    lazy var currentStore = BehaviorRelay<Store>(value: store)

    private(set) var store: Store

    var disposeBag = DisposeBag()
    
    var service: UserService


    init(store: Store = Store(), service: UserService = UserService() ) {
        self.store = store
        self.service = service
        
        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }

    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .myInfo:
            return service.signin()
                .asObservable()
                .map{ response -> Mutation in
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let servertype = ServerWrapper(rawValue: response!.statusCode)
                    
                    if let data = response?.data , let decodeData = try? decoder.decode(User.self, from: data) {
                        return .setUser(decodeData)
                    }
                    else {
                        return .setError(servertype)
                    }
                }
        }
        
    }

    private func reduce(_ muation: Mutation) -> Observable<Store> {
        
        switch muation {
        case .setUser(let user):
            store.user = user
        case .setError(let error):
            store.errorType = error
        }

        return .just(store)
    }
}
