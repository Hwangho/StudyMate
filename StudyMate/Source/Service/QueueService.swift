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
    func queueState() -> Single<Response?>
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
    
    func queueState() -> Single<Response?> {
        return repository
            .queueState()
            .map { $0 }
    }

}
