//
//  UserService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import RxSwift


protocol UserServiceProtocool {
    func signin() -> Single<ResponseWrapper<User>?>
}


struct UserService: UserServiceProtocool {

    
    let repository: UserRepositoryPorotocool
    
    init(repository: UserRepositoryPorotocool = UserRepository()) {
        self.repository = repository
    }
    
    func signin() -> RxSwift.Single<ResponseWrapper<User>?> {
        return repository
            .signin()
            .map { $0 }
//            .catchErrorJustReturn(nil)
    }
    
}
