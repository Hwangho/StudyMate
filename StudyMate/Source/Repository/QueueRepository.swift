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
    func searchStudy(lat: Double, long: Double, studyList: [String]) -> Single<Response>
    func stop() -> Single<Response>
    func queueState() -> Single<Response>
    func studyrequest(uid: String) -> Single<Response>
    func studyaccept(uid: String) -> Single<Response>
}


struct QueueRepository: QueueRepositoryPorotocool {
    
    let provider: MoyaProvider<QueueRouter>
    
    init(provider: MoyaProvider<QueueRouter> = MoyaProvider<QueueRouter>() ) {
        self.provider = provider
    }
    
    func search(lat: Double, long: Double) -> Single<Response> {
        return provider.rx.request(.search(lat, long))
    }
    
    func searchStudy(lat: Double, long: Double, studyList: [String]) -> Single<Response> {
        return provider.rx.request(.searchStudy(lat, long, studyList))
    }
    
    func stop() -> Single<Response> {
        return provider.rx.request(.stop)
    }
    
    func queueState() -> Single<Response> {
        return provider.rx.request(.queueState)
    }
    
    func studyrequest(uid: String) -> Single<Response> {
        return provider.rx.request(.studyrequest(uid))
    }
    
    func studyaccept(uid: String) -> Single<Response> {
        return provider.rx.request(.studyaccept(uid))
    }
}

