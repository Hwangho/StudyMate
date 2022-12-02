//
//  QueueService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//

import Moya
import RxSwift
import RxCocoa


protocol QueueServiceProtocool {
    func search(lat: Double, long: Double) -> Single<Response?>
    func searchStudy(lat: Double, long: Double, studyList: [String]) -> Single<Response?>
    func stop() -> Single<Response?>
    func queueState() -> Single<Response?>
    func studyrequest(uid: String) -> Single<Response?>
    func studyaccept(uid: String) -> Single<Response?>
}


struct QueueService: QueueServiceProtocool {

    let repository: QueueRepositoryPorotocool
    
    init(repository: QueueRepositoryPorotocool = QueueRepository()) {
        self.repository = repository
    }
    
    func search(lat: Double, long: Double) -> Single<Response?> {
        return repository
            .search(lat: lat, long: long)
            .map { $0 }
    }
    
    func searchStudy(lat: Double, long: Double, studyList: [String]) -> Single<Response?> {
        return repository
            .searchStudy(lat: lat, long: long, studyList: studyList)
            .map{ $0 }
    }
    
    func stop() -> Single<Response?>{
        return repository
            .stop()
            .map{ $0 }
    }
    
    func queueState() -> Single<Response?> {
        return repository
            .queueState()
            .map { $0 }
    }

    func studyrequest(uid: String) -> Single<Response?> {
        return repository
            .studyrequest(uid: uid)
            .map{ $0 }
    }
    
    func studyaccept(uid: String) -> Single<Response?> {
        return repository
            .studyaccept(uid: uid)
            .map{ $0 }
    }
}
