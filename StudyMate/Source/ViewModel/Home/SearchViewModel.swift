//
//  SearchViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/25.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import NMapsMap


final class SearchViewModel {

    enum Action {
        case searchSesac(Double, Double)
        case searchStudy(Double, Double, [String])
        case addStudy(String)
        case deleteStudy(String)
    }

    enum Mutation {
        case setStudyList([RecomandStudys])
        
        case setSearchStudyType(SearchStudyType)
        case setError(QueueResponseType?)
        case setMyStudy([String])
        case setListIsFull(Bool)
    }

    struct Store {
        var recomandStudy: [RecomandStudys]?
        var searchStudyType: SearchStudyType?
        var errorType: QueueResponseType?
        
        var searchStudyList: [String] = []
        var studyListIsFull: Bool = false
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
                        let recomandStudy = self?.sortRecomandStudy(queue: decodeData)
                        return .setStudyList(recomandStudy!)
                    }
                    else {
                        return .setError(servertype)
                    }
                }
            
        case .searchStudy(let lat, let long, let studyList):
            return service.searchStudy(lat: lat, long: long, studyList: studyList)
                .asObservable()
                .map { response -> Mutation in
                    guard let servertype = SearchStudyType(rawValue: response!.statusCode) else {return .setSearchStudyType(.clientError) }
                    return .setSearchStudyType(servertype)
                }
            
        case .addStudy(let study):
            var StudyList = store.searchStudyList
            var isFull = false
            
            if StudyList.count < 8 {
                if !StudyList.contains(study) {
                    StudyList.append(study)
                    isFull = false
                }
            } else {
                isFull = true
            }
            
            return .concat([
                .just(.setMyStudy(StudyList)),
                .just(.setListIsFull(isFull))
            ])
            
        case .deleteStudy(let study):
            var StudyList = store.searchStudyList
            
            if let firstIndex = StudyList.firstIndex(of: study) {
                StudyList.remove(at: firstIndex)
            }
            
            return .concat([
                .just(.setListIsFull(false)),
                .just(.setMyStudy(StudyList))
            ])
        }
        
    }
    
    private func reduce(_ muation: Mutation) -> Observable<Store> {
        switch muation {
        case .setStudyList(let studyList):
            store.recomandStudy = studyList
            
        case .setSearchStudyType(let type):
            store.searchStudyType = type
            
        case .setError(let error):
            store.errorType = error
            
        case .setMyStudy(let studyList):
            store.searchStudyList = studyList
            
        case .setListIsFull(let isFull):
            store.studyListIsFull = isFull
        }
        
        return .just(store)
    }
    
}


// MARK: - Custom
extension SearchViewModel {
    func sortRecomandStudy(queue: Queue) -> [RecomandStudys] {

        var all: [String] = []
        
        queue.fromQueueDB.forEach {
            $0.studylist.forEach {
                all.append($0)
            }
        }
        
        queue.fromQueueDBRequested.forEach {
            $0.studylist.forEach {
                all.append($0)
            }
        }
        
        let studySet = Set(all)
        let studyList = Array(studySet).sorted()
        
        let around = studyList.map { value in
            RecomandStudys(type: .around, title: value)
        }
        
        var recomand = queue.fromRecommend.map { value in
            RecomandStudys(type: .recomand, title: value)
        }
        around.forEach {
            recomand.append($0)
        }

        return recomand
    }

    func removeDuplication(in array: [Int]) -> [Int]{
        let set = Set(array)
        let duplicationRemovedArray = Array(set)
        return duplicationRemovedArray
    }
}



enum SearchStudyType: Int {
    case success = 200
    case threeTimereported = 201
    case penaltyOne = 203
    case penaltyTwo = 204
    case penaltyThree = 205
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .success: return "스터디 함께할 새싹 찾기 요청 성공"
        case .threeTimereported: return "신고하기 3번 이상 받은 유저"
        case .penaltyOne: return "스터디 취소 페널티 1단계"
        case .penaltyTwo: return "스터디 취소 페널티 페널티 2단계"
        case .penaltyThree: return "스터디 취소 페널티 페널티 3단계"
        case .FireBaseToken: return "Firebase Token Error"
        case .noneSignup: return "미가입 회원"
        case .serverError: return "Server Error"
        case .clientError: return "Client Error"
        }
    }
}
