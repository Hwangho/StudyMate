//
//  OnBoardingViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxRelay


class CertificationViewModel {
    
    
    
    enum Action {
        case inputText(Certification, String)
        case doneButton(Certification)
    }
    
    enum Mutation {
        case setphoneNumber(String)
        case setCertificationNumber(String)
        case setTextValid(Bool)
        
        case reciveMessage(Bool)
        case reciveCertification(Bool)
    }
    
    struct Store {
        var phoneNumber: String?
        var certificationNumber: String?
        var checkNumberValid = false
        var checkReciveMessage = false
        var checkCertification = false
    }
    
    
    /// Properties
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    let service: CertificationServiceprotocool
    
    let userservice = UserService()
    
    /// initialization
    init(store: Store = Store(), service: CertificationServiceprotocool = CertificationService()) {
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
        case .inputText(let type, let text):
            
            switch type {
            case .phoneNumber:
                var text = text
                if text.count > 11 {
                  let index = text.index(text.startIndex, offsetBy: 11)
                    text = String(text[..<index])
                }
                
                let valid =  text.count >= 10 && text.count <= 11 && text.starts(with: "01") ? true : false
                
                return .concat([
                    Observable.just(.setphoneNumber(text)),
                    Observable.just(.setTextValid(valid))
                ])
                
            case .certificationNumber:
                var text = text
                if text.count > 6 {
                  let index = text.index(text.startIndex, offsetBy: 6)
                    text = String(text[..<index])
                }
                
                let valid =  text.count == 6 ? true : false
                
                return .concat([
                    Observable.just(.setCertificationNumber(text)),
                    Observable.just(.setTextValid(valid))
                ])
            }
          
        case .doneButton(let type):
            switch type {
            case .phoneNumber:
                /// api 통신으로 전화번호 보내고 error 없이 잘 받아오면 True 넘기기  안되면 error 도 같이 보내줘야 될듯!!
                store.phoneNumber?.removeFirst()
                let phoneNumber = "+82" + (store.phoneNumber ?? "")
                
                return service.verifyPhoneNumber(phoneNumber: "+821066841636")
                    .asObservable()
                    .map { value in
                        LocalUserDefaults.shared.set(key: .FirebaseidToken, value: value)
                        return .reciveMessage(true)
                    }
                
            case .certificationNumber:
                ///  인증번호 확인 & 서버에 인증 되었는지 체크!                
                return .just(.reciveCertification(true))
            }
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setphoneNumber(let text):
            store.phoneNumber = text
            
        case .setCertificationNumber(let text):
            store.certificationNumber = text
            
        case .setTextValid(let value):
            store.checkNumberValid = value
            
        case .reciveMessage(let value):
            store.checkReciveMessage = value
            
        case .reciveCertification(let value):
            store.checkCertification = value
        }
        return .just(store)
    }
    
}


