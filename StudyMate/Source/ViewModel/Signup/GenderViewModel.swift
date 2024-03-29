//
//  GenderViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import UIKit

import Moya
import RxSwift
import RxCocoa
import RxRelay


final class GenderViewModel {
    
    enum Action {
        case tapGender(Int)
        case doneButton
    }
    
    enum Mutation {
        case setGender(Int)
        case setGenderValid(Bool)
        
        case setError(ServerWrapper)
        case setSuccess(Bool)
    }
    
    struct Store {
        var gender: Int?
        var checkGenderValid = false
        var errorType: ServerWrapper?
        
        var sucess = false
    }
    
    
    /// Properties
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    let service: UserServiceProtocool
    
    
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
        case .tapGender(let value):
            
            let value = value == 0 ?  1: 0
            LocalUserDefaults.shared.set(key: .gender, value: value)
            
            return .concat([
                .just(.setGender(value)),
                .just(.setGenderValid(true))
            ])
            
        case .doneButton:
            let phoneNumber: String? = LocalUserDefaults.shared.value(key: .phoneNumber)
            let nickname: String? = LocalUserDefaults.shared.value(key: .nickName)
            let birth: String? = LocalUserDefaults.shared.value(key: .birth)
            let email: String? = LocalUserDefaults.shared.value(key: .email)
            let gender: Int? = LocalUserDefaults.shared.value(key: .gender)
            
            LocalUserDefaults.shared.checkUserDefualt()
            
            let FCMToken: String? = LocalUserDefaults.shared.value(key: .FCMToken)
            
            return service
                .signup(phoneNumber!, nickname!, birth!, email!, gender!)
                .asObservable()
                .map{ response -> Mutation in
                    guard let statusCode = response?.statusCode else { return  .setSuccess(false) }
                    print(statusCode)
                    
                    if statusCode == 200 {
                        return .setSuccess(true)
                    } else {
                        let type: ServerWrapper = ServerWrapper(rawValue: statusCode)!
                        return .setError(type)
                    }
                }
        }
        
    }

    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {

        case .setGender(let value):
            store.gender = value
            
        case .setGenderValid(let value):
            store.checkGenderValid = value
            
        case .setError(let type):
            store.errorType = type
            
        case .setSuccess(let value):
            store.sucess = value
        }
        return .just(store)
    }
}


