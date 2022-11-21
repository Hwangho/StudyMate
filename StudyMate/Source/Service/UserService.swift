//
//  UserService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import Moya
import RxSwift
import RxCocoa


protocol UserServiceProtocool {
    
    func signin() -> Single<Response?>
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<Response?>
    func withdraw() -> Single<Response?>
}


struct UserService: UserServiceProtocool {

    let repository: UserRepositoryPorotocool
    
    init(repository: UserRepositoryPorotocool = UserRepository()) {
        self.repository = repository
    }
    
    func signin() -> Single<Response?>{
        return repository
            .signin()
            .map { $0 }
    }
    
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<Response?> {
        return repository
            .signup(phoneNumber, nick, birth, email, gender)
            .map { $0 }
    }
    
    func withdraw() -> Single<Response?> {
        return repository
            .withdraw()
            .map { $0 }
    }
}
