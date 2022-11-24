//
//  QueueRouter.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//


import Moya


enum QueueRouter {
    case search(Double, Double)
}

extension QueueRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIKeys.shared.server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/queue/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        }
    }
    
    var parameters: [String: Any] {
//        let FCMToken: String? = LocalUserDefaults.shared.value(key: .FCMToken)
        
        switch self {
       
        case .search(let lat, let long):
            return [
                "lat": lat,
                "long": long,
            ]

        }
    }
    
    var task: Moya.Task {
        switch self {
            
        default:
            return .requestParameters(
                parameters: self.parameters,
                encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        let idToken: String? = LocalUserDefaults.shared.value(key: .FirebaseidToken)
        
        switch self {
        default:
            return [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": "\(idToken ?? "")"
            ]
            
        }
    }
    
}
