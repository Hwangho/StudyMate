//
//  HomeViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import NMapsMap


final class HomeViewModel {

    enum Action {
        case searchSesac(Double, Double)
        case queueState
    }

    enum Mutation {
        case setQueueData([NMFMarker], [NMFMarker], [NMFMarker])
        case setError(QueueResponseType?)
        case setQueueState(QueueState?)
        case setQueuestateError(QueueStateResponseType?)
    }

    struct Store {
        var errorType: QueueResponseType?
        var queuestateError: QueueStateResponseType?
        var allMarker: [NMFMarker] = []
        var manMarker: [NMFMarker] = []
        var womanMarker: [NMFMarker] = []
        
        var queueState: QueueState?
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
            .flatMap(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .searchSesac(let lat, let long):
            return service.search(lat: lat, long: long)
                .asObservable()
                .map { response in
                    let decoder = JSONDecoder()
                    let servertype = QueueResponseType(rawValue: response!.statusCode)
                    
                    if let data = response?.data , let decodeData = try? decoder.decode(Queue.self, from: data) {
                        var allMarker: [NMFMarker] = []
                        var manMarker: [NMFMarker] = []
                        var womanMarker: [NMFMarker] = []
                        
                        decodeData.fromQueueDB.forEach { User in
                            let marker = NMFMarker()
                            marker.position = NMGLatLng(lat: User.lat, lng: User.long)
                            marker.iconImage = NMFOverlayImage(name: User.sesac)
                            marker.width = 80
                            marker.height = 80
                            allMarker.append(marker)
                            User.gender == 1 ? manMarker.append(marker): womanMarker.append(marker)
                        }
                        return .setQueueData(allMarker, manMarker, womanMarker)
                    }
                    else {
                        return .setError(servertype)
                    }
                }
        case .queueState:
            return service.queueState()
                .asObservable()
                .map { response in
                    let decoder = JSONDecoder()
                    let servertype = QueueStateResponseType(rawValue: response!.statusCode)

                    if let data = response?.data, let decodeData = try? decoder.decode(QueueState.self, from: data) {
                        return .setQueueState(decodeData)
                    }
                    else if servertype == .normal {
                        return .setQueueState(nil)
                    } else {
                        return .setQueuestateError(servertype)
                    }
                }
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        switch muation {
        case .setQueueData(let all, let man, let woman):
            store.allMarker.forEach {
                $0.mapView = nil
            }
            
            store.allMarker = all
            store.manMarker = man
            store.womanMarker = woman
            
        case .setError(let error):
            store.errorType = error
            
        case .setQueueState(let queueState):
            store.queueState = queueState
            
        case .setQueuestateError(let type):
            store.queuestateError = type
        }
        
        return .just(store)
    }
    
}
