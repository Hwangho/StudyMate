//
//  LookupStudyViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/29.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import NMapsMap


final class LookupStudyViewModel {

    enum Action {
        case searchSesac(Double, Double)
    }

    enum Mutation {
        case setQueue(Queue)
        case setError(QueueResponseType?)
    }

    struct Store {
        var queue: Queue?
        var errorType: QueueResponseType?
    }

    
    let action = PublishRelay<Action>()

    lazy var currentStore = BehaviorRelay<Store>(value: store)

    private(set) var store: Store

    var disposeBag = DisposeBag()

    let service: QueueServiceProtocool


    init(store: Store = Store(), serive: QueueServiceProtocool = QueueService() ) {
        self.store = store
        self.service = serive

        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .searchSesac(let lat, let long):
            return service.search(lat: lat, long: long)
                .asObservable()
                .map { [weak self] response -> Mutation in
                    let decoder = JSONDecoder()
                    let servertype = QueueResponseType(rawValue: response!.statusCode)
                    
                    if let data = response?.data , let decodeData = try? decoder.decode(Queue.self, from: data) {
                        return .setQueue(decodeData)
                    }
                    else {
                        return .setError(servertype)
                    }
                }
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        switch muation {
        case .setQueue(let queue):
            store.queue = queue
        case .setError(let error):
            store.errorType = error
        }
        
        
        return .just(store)
    }
    
}
