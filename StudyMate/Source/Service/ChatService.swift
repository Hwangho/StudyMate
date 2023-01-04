//
//  ChatService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import Moya
import RxSwift
import RxCocoa


protocol ChatServiceProtocool {
    func lastchatDate(uid: String, lastDate: String?) -> Single<Response?>
}


struct ChatService: ChatServiceProtocool {

    let repository: ChatRepositoryPorotocool
    
    init(repository: ChatRepositoryPorotocool = ChatRepository()) {
        self.repository = repository
    }
    
    func lastchatDate(uid: String, lastDate: String?) -> Single<Response?> {
        return repository.lastchatDate(uid: uid, lastDate: lastDate)
            .map { $0 }
    }
}
