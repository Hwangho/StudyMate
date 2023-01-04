//
//  QueueRouter.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//


import Moya


enum QueueRouter {
    case search(Double, Double)
    case searchStudy(Double, Double, [String])
    case stop
    case queueState
    case studyrequest(String)
    case studyaccept(String)
    case dodge(String)
    case review(String, [Int], String)
}

extension QueueRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIKeys.shared.server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/queue/search"
            
        case .searchStudy, .stop:
            return "/v1/queue"
            
        case .queueState:
            return "/v1/queue/myQueueState"
            
        case .studyrequest:
            return "/v1/queue/studyrequest"
            
        case .studyaccept:
            return "/v1/queue/studyaccept"
            
        case .dodge:
            return "/v1/queue/dodge"
            
        case .review(let uid, _, _):
            return "/v1/queue/rate/\(uid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search, .searchStudy, .studyrequest, .studyaccept:
            return .post
            
        case .stop:
            return .delete
            
        default:
            return .get
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
            
        case .searchStudy(let lat, let long, let studyList):
            let studylist = studyList.isEmpty ? ["anything"] : studyList
            return [
                "lat": lat,
                "long": long,
                "studylist": studylist
            ]

        case .studyrequest(let uid), .studyaccept(let uid), .dodge(let uid):
            return ["otheruid": uid]
            
        case .review(let uid, let checkList, let review):
            return [
                "otheruid" : uid,
                "reputation": checkList,
                "comment" : review
            ]
            
        default:
            return [:]
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchStudy, .review:
            return .requestParameters(
                parameters: self.parameters,
                encoding: URLEncoding(arrayEncoding: .noBrackets))
            
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
