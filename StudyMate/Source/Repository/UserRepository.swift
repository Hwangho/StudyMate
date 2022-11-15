//
//  UserRepository.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import Moya
import RxCocoa
import RxSwift


protocol UserRepositoryPorotocool {
    func signin() -> Single<ResponseWrapper<User>>
//    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int)
}

struct UserRepository: UserRepositoryPorotocool {
    
    let provider: MoyaProvider<UserRouter>
    
    init(provider: MoyaProvider<UserRouter> = MoyaManager.default.createProvider()) {
        self.provider = ProcessInfo.processInfo.getStubProvider(target: UserRouter.self) ?? provider
    }
    
    
    func signin() -> RxSwift.Single<ResponseWrapper<User>> {
        return provider.rx.request(.signin)
            .map(ResponseWrapper<User>.self)
    }
    
//    func signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int) {
//        <#code#>
//    }
}









struct MoyaManager {
    
    static let `default` = MoyaManager()

    
    private init() {}
    
    func createProvider<T>() -> MoyaProvider<T> {
        return MoyaProvider(
            endpointClosure: EndpointManager.default.createEndpoint(target:),
            plugins: [NetworkLoggerPlugin()]
        )
    }
    
}


struct EndpointManager {
   
   static let `default` = EndpointManager()

   
   private init() {}
   
   func createEndpoint(target: TargetType) -> Endpoint {
       return Endpoint(
           url: target.baseURL.absoluteString + target.path,
           sampleResponseClosure: { .networkResponse(200, target.sampleData) },
           method: target.method,
           task: target.task,
           httpHeaderFields: target.headers?.merging(["Accept-Language": Locale.current.languageCode!]) { _, new in new }
       )
   }
   
}



extension ProcessInfo {
    
    func isContainsArguments(key: String) -> Bool {
        return arguments.contains(key)
    }
    
    /// launchArguments 체크하여 stubbing 여부 체크
    func getStubProvider<T: TargetType>(target: T.Type) -> MoyaProvider<T>? {
        guard isContainsArguments(key: "UI-Testing") else { return nil }
        
        return MoyaProvider<T>(
            stubClosure: MoyaProvider.delayedStub(0.1),
            plugins: [NetworkLoggerPlugin()]
        )
    }
    
}


import Foundation


struct ResponseWrapper<T: Decodable & Equatable>: ModelType, Decodable {
    var success: Bool
    var code: Int
    var title: String?
    var msg: String
    var data: T?
    var errKey: String?
    var createAt: Date  /// viewModel에서 해당 model의 변경을 감지하기 위해 사용
    let error: ResponseError
    
    
    enum CodingKeys: String, CodingKey {
        case success
        case code
        case title
        case msg
        case data
        case errKey
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        code = try values.decode(Int.self, forKey: .code)
        title = try? values.decode(String.self, forKey: .title)
        msg = try values.decode(String.self, forKey: .msg)
        data = try? values.decode(T.self, forKey: .data)
        errKey = try? values.decode(String.self, forKey: .errKey)
        createAt = Date()
        error = ResponseError(message: msg)
    }
}


extension ResponseWrapper: Equatable {
    
    static func == (lhs: ResponseWrapper<T>, rhs: ResponseWrapper<T>) -> Bool {
        return lhs.createAt == rhs.createAt
    }
    
}




protocol ModelType: Decodable {
    
}

extension ModelType {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}



struct ResponseError: Error, Hashable {
    let message: String
    let createAt: Date
    
    init(message: String) {
        self.message = message
        createAt = Date()
    }
}





struct User: Codable, Hashable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}
