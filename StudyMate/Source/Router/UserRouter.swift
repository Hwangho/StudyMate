//
//  UserRouter.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import Moya


enum UserRouter {
    case signin
    case signup(_ phoneNumber: String, _ nick: String, _ birth: String, _ email: String, _ gender: Int)
    case withdraw
}

extension UserRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIKeys.shared.server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signin, .signup: return "/v1/user"
        case .withdraw: return "/v1/user/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup, .withdraw: return .post
        default: return .get
        }
    }
    
    var parameters: [String: Any] {
        let FCMToken: String? = LocalUserDefaults.shared.value(key: .FCMToken)
        switch self {
        case .signup(let phoneNumber, let nick, let birth, let email, let gender):
            return [ "phoneNumber" : phoneNumber,
                     "FCMtoken" : FCMToken ?? "",
                     "nick": nick,
                     "birth": birth,
                     "email": email,
                     "gender" : gender
                   ]
        
        default: return [:]
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        default:
            return .requestParameters(
                parameters: self.parameters,
                encoding: URLEncoding.default)
            
//        default: return .requestPlain
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
