//
//  ChatRepository.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import Moya
import RxCocoa
import RxSwift


protocol ChatRepositoryPorotocool {
    func lastchatDate(uid: String, lastDate: String?) -> Single<Response>
}


struct ChatRepository: ChatRepositoryPorotocool {
    
    let provider: MoyaProvider<ChatRouter>
    
    init(provider: MoyaProvider<ChatRouter> = MoyaProvider<ChatRouter>() ) {
        self.provider = provider
    }
    
    func lastchatDate(uid: String, lastDate: String?) -> Single<Response> {
        return provider.rx.request(.lastchatDate(uid, lastDate))
        
    }
    

}

