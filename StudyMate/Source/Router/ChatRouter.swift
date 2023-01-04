//
//  ChatRouter.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import Moya


enum ChatRouter {
    case sendChat(String, String)
    case lastchatDate(String, String?)
}

extension ChatRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIKeys.shared.server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sendChat(let uid, _):
            return "/v1/chat/\(uid)"
            
        case .lastchatDate(let uid, let lastDate):
            let Date = lastDate != nil ? lastDate : "2000-01-01T00:00:00.000Z"
            return "/v1/chat/\(uid)?lastchatDate=\(Date!)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendChat:
            return .post
            
        default:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        
        switch self {
        case .sendChat(_, let chat):
            return [ "chat" : chat]
            
        default:
            return [:]
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
