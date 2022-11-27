//
//  QueueRepository.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//

import Moya
import RxCocoa
import RxSwift


protocol QueueRepositoryPorotocool {
    func search(lat: Double, long: Double) -> Single<Response>
    func queueState() -> Single<Response>
}


struct QueueRepository: QueueRepositoryPorotocool {
    
    let provider: MoyaProvider<QueueRouter>
    
    init(provider: MoyaProvider<QueueRouter> = MoyaProvider<QueueRouter>() ) {
        self.provider = provider
    }
    
    func search(lat: Double, long: Double) -> Single<Response> {
        
        return provider.rx.request(.search(lat, long))
    }
    func queueState() -> Single<Response> {
        return provider.rx.request(.queueState)
    }
    
}

