//
//  ResponseWrapper.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import Foundation


protocol ModelType: Decodable {
    
}

extension ModelType {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}


//struct ResponseWrapper<T: Decodable & Equatable>: ModelType, Decodable {
//    var statusCode: Int
//    var data: T?
//    var error: Error?
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case statusCode
//        case data
//        case error
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        statusCode = try values.decode(Int.self, forKey: .statusCode)
//        data = try? values.decode(T.self, forKey: .data)
////        data = try? values.decodeIfPresent(T.self, forKey: .data)
////        error = try? values.decode(Error.self, forKey: .error)
//    }
//}






/// response 에 데이터가 없는 경우
struct NoneResponseWrapper<T>: Decodable {
    var statusCode: Int
    var data: T?
    var error: Error?
    
    
    enum CodingKeys: String, CodingKey {
        case statusCode
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decode(Int.self, forKey: .statusCode)
    }
    
}






import Moya
import RxSwift


public extension Reactive where Base: MoyaProviderType {
    
    
    func SLPrequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                
                switch result {
                case let .success(response):
                    
                    
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
}







class NetworkWrapper<Provider : TargetType> : MoyaProvider<Provider> {
    
    init(endPointClosure : @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         stubClosure : @escaping StubClosure = MoyaProvider.neverStub,
         plugins : [PluginType] ){
        
        let session = MoyaProvider<Provider>.defaultAlamofireSession()
        
        session.sessionConfiguration.timeoutIntervalForRequest = 20
        session.sessionConfiguration.timeoutIntervalForResource = 20
        
        super.init(endpointClosure: endPointClosure, stubClosure: stubClosure, session: session, plugins: plugins)
    }
    
    func requestSuccessRes<Model : Codable>(target : Provider, instance : Model.Type , completion : @escaping(Result<Model, SLPError>) -> () ){
        self.request(target) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                
                if statusCode == 200 {
                    if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
                        completion(.success(decodeData))
                    }
                }
                else if statusCode == 201 {
                    completion(.failure(.alreadySignupError))
                }
                else if statusCode == 202 {
                    completion(.failure(.nickNameError))
                }
                else if statusCode == 401 {
                    completion(.failure(.FireBaseToken))
                }
                else if statusCode == 406 {
                    completion(.failure(.noneSignup))
                }
                else if statusCode == 500 {
                    completion(.failure(.serverError))
                }
                else if statusCode == 501 {
                    completion(.failure(.clientError))
                }
                else {
                    print(statusCode)
                }
                
            case .failure(let error):
                completion(.failure(.error(error)))
            }
        }
    }
    
}

class CustomPlugIn : PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("URL Request - \(target) : \(request.url?.absoluteString ?? "없음")")
        return request
    }

    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>{
        print("URL Response - \(target) : \(result)")
        return result
    }

}




enum SLPError: Error {
    case error(Error)
    case alreadySignupError
    case nickNameError
    case FireBaseToken
    case noneSignup
    case serverError
    case clientError
}





enum FirebaseError: Int, Error {
    // 전화 인증
    case certificationNumber = 17044
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
