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
        case saveLocation(Double?, Double?)
        case searchSesac
        case stopSearch
        
        case studyrequest
        case studyaccept
        
        case saveUID(String?)
    }

    enum Mutation {
        case setLocation(Double?, Double?)
        case setQueue(Queue)
        case setError(QueueResponseType?)
        case setStop(StopSearchType)
        
        case setRequestServer(StudyRequest)
        case setAcceptServer(StudyAccept)
        
        case setSaveUID(String?)
    }

    struct Store {
        var location: (Double?, Double?)?
        var queue: Queue?
        var errorType: QueueResponseType?
        var stopSearchType:StopSearchType?
        
        var requestStatusType: StudyRequest?
        var acceptStatusType: StudyAccept?
        
        var UID: String?
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
            
        case .saveLocation(let lat, let lng):
            return .just(.setLocation(lat, lng))
            
        case .searchSesac:
            let lat = store.location?.0 != nil ? store.location?.0 : LocalUserDefaults.shared.value(key: .lat)
            let lng = store.location?.1 != nil ? store.location?.1 : LocalUserDefaults.shared.value(key: .lng)
            
            return service.search(lat: lat!, long: lng!)
                .asObservable()
                .map { response -> Mutation in
                    let decoder = JSONDecoder()
                    let servertype = QueueResponseType(rawValue: response!.statusCode)
                    
                    if let data = response?.data , let decodeData = try? decoder.decode(Queue.self, from: data) {
                        return .setQueue(decodeData)
                    }
                    else {
                        return .setError(servertype)
                    }
                }
            
        case .stopSearch:
            return service.stop()
                .asObservable()
                .map { response in
                    guard let statusCode = response?.statusCode else { return .setStop(.clientError)}
                    let type = StopSearchType(rawValue: statusCode)
                    return .setStop(type ?? .clientError)
                }
            
        case .studyrequest:
            guard let uid = store.UID else {return .just(.setRequestServer(.clientError))}
            
            return service.studyrequest(uid: uid)
                .asObservable()
                .map { response in
                    guard let statusCode = response?.statusCode else { return .setRequestServer(.clientError)}
                    
                    let type = StudyRequest(rawValue: statusCode)
                    return .setRequestServer(type ?? .clientError)
                }
            
        case .studyaccept:
            guard let uid = store.UID else {return .just(.setAcceptServer(.clientError))}
            
            return service.studyaccept(uid: uid)
                .asObservable()
                .map { response in
                    guard let statusCode = response?.statusCode else { return .setAcceptServer(.clientError)}
                    let type = StudyAccept(rawValue: statusCode)
                    return .setAcceptServer(type ?? .clientError)
                }
            
        case .saveUID(let uid):
            return .just(.setSaveUID(uid))
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        switch muation {
            
        case .setLocation(let lat, let lng):
            store.location = (lat, lng)
            
        case .setQueue(let queue):
            store.queue = queue
            
        case .setStop(let type):
            store.stopSearchType = type
            
        case .setError(let error):
            store.errorType = error
            
        case .setRequestServer(let type):
            store.requestStatusType = type
            
        case .setAcceptServer(let type):
            store.acceptStatusType = type
            
        case .setSaveUID(let uid):
            store.UID = uid
        }
        return .just(store)
    }
    
}



enum StopSearchType: Int {
    case success = 200
    case matched = 201
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .success: return "스터디 함께할 새싹 찾기 중단 성공~"
        case .matched: return "매칭 상태로 새싹 찾기는 이미 중단된 상태"
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default: return "error가 발생하였습니다."
        }
    }
}


enum StudyRequest: Int {
    case success = 200
    case matched = 201
    case stopStudy = 202
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .success: return "성공~"
        case .matched: return "상대방이 이미 나에게 스터디 요청한 상태"
        case .stopStudy: return "상대방이 새싹 찾기를 중단한 상태"
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default: return "error가 발생하였습니다."
        }
    }
}


enum StudyAccept: Int {
    case success = 200
    case healreadyMatched = 201
    case stopStudy = 202
    case already = 203
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .success: return "성공~"
        case .healreadyMatched: return "상대방이 이미 다른 사용자와 매칭된 상태"
        case .stopStudy: return "상대방이 새싹 찾기를 중단한 상태"
        case .already: return "내가 이미 다른 사용자와 매칭된 상태"
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default: return "error가 발생하였습니다."
        }
    }
}
