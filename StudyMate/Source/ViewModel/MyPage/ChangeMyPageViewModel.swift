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
        case saveMyInfo
        
        case mygender(Int)
        case study(String?)
        case searchAllow(Int)
        case age(Int, Int)
    }

    enum Mutation {
        case setUser(User)
        case setError(ServerWrapper?)
        case saveMyInfo(MyPageResponseType)
        
        case setMygender(Int)
        case setStudy(String?)
        case setSearchAllow(Int)
        case setAge(Int, Int)
    }

    struct Store {
        var user: User?
        var errorType: ServerWrapper?
        
        var myInfoStatusType: MyPageResponseType?
        var mygender: Int?
        var study: String?
        var searchAllow: Int?
        var minage: Int?
        var maxage: Int?
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
            
        case .saveMyInfo:
            let serachable = store.searchAllow
            let ageMin = store.minage
            let ageMax = store.maxage
            let gender = store.mygender
            let study = store.study
            
           return service.changeMypage(serachable!, ageMin!, ageMax!, gender!, study!)
                .asObservable()
                .map { response -> Mutation in
                    let servertype = MyPageResponseType(rawValue: response!.statusCode)
                    return .saveMyInfo(servertype!)
                }
            
            
            
        case .mygender(let gender):
            return .just(.setMygender(gender))
            
        case .study(let value):
            return .just(.setStudy(value))
            
        case .searchAllow(let isOn):
            return .just(.setSearchAllow(isOn))
            
        case .age(let min, let max):
            return .just(.setAge(min, max))
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        
        switch muation {
        case .setUser(let user):
            store.user = user
        case .setError(let error):
            store.errorType = error
            
        case .setMygender(let gender):
            store.mygender = gender
            
        case .setStudy(let studty):
            store.study = studty
            
        case .setSearchAllow(let allow):
            store.searchAllow = allow
            
        case .setAge(let min, let max):
            store.minage = min
            store.maxage = max
            
        case .saveMyInfo(let type):
            store.myInfoStatusType = type
            
            break
        }
        
        return .just(store)
    }
}


enum MyPageResponseType: Int {
    case sucess = 200
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .sucess: return "성공~"
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default:
            return "error가 발생하였습니다."
        }
    }
}
