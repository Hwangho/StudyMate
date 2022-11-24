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
                .map { response -> Mutation in
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
                .map { response -> Mutation in
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




// MARK: - QueueState
struct QueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
    
    enum CodingKeys: String, CodingKey {
        case dodged, matched, reviewed
        case matchedNick, matchedUid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dodged = try values.decode(Int.self, forKey: .dodged)
        matched = try values.decode(Int.self, forKey: .dodged)
        reviewed = try values.decode(Int.self, forKey: .dodged)
        matchedNick = try values.decodeIfPresent(String.self, forKey: .dodged) ?? ""
        matchedUid = try values.decodeIfPresent(String.self, forKey: .dodged) ?? ""
    }
    
}


enum QueueStateResponseType: Int {
    case sucess = 200
    case normal = 201
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .sucess: return "성공~"
        case .normal: return "일반 상태"
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default: return "error가 발생하였습니다."
        }
    }
}
