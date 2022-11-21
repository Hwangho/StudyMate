//
//  UserRepository.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import Moya
import RxCocoa
import RxSwift


protocol UserRepositoryPorotocool {
    
    func signin() -> Single<Response>
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<Response>
    func withdraw() -> Single<Response>
    func changeMypage(_ searchable: Int, _ ageMin: Int, _ ageMax: Int, _ gender: Int, _ study: String) -> Single<Response>
}

struct UserRepository: UserRepositoryPorotocool {
    
    let provider: MoyaProvider<UserRouter>
    
    init(provider: MoyaProvider<UserRouter> = MoyaProvider<UserRouter>() ) {
        self.provider = provider
    }
    
    
    func signin() -> Single<Response> {
        return provider.rx.request(.signin)
//            .map(ResponseWrapper<User>.self)
    }
    
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<Response> {
        return provider.rx.request(.signup(phoneNumber, nick, birth, email, gender))
    }
    
    func withdraw() -> Single<Response> {
        return provider.rx.request(.withdraw)
    }
    
    func changeMypage(_ searchable: Int, _ ageMin: Int, _ ageMax: Int, _ gender: Int, _ study: String) -> Single<Response> {
        return provider.rx.request(.changeMypage(searchable, ageMin, ageMax, gender, study))
    }
}

