//
//  UserService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import RxSwift


protocol UserServiceProtocool {
    
    func signin() -> Single<ResponseWrapper<User>?>
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<ResponseWrapper<Int>?>
}


struct UserService: UserServiceProtocool {

    let repository: UserRepositoryPorotocool
    
    init(repository: UserRepositoryPorotocool = UserRepository()) {
        self.repository = repository
    }
    
    func signin() -> Single<ResponseWrapper<User>?>{
        return repository
            .signin()
            .map { $0 }
    }
    
    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) -> Single<ResponseWrapper<Int>?> {
        return repository
            .signup(phoneNumber, nick, birth, email, gender)
            .map { $0 }
    }
}
