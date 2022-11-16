//
//  APIKeys.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import UIKit


struct APIKeys {
    
    enum BuildType {
        case test
        case real
    }
    
    static let shared = APIKeys(type: .test)
    
    let server: Server
    
    
    init(type: BuildType = .test) {
        server = Server(type: type)
    }
    
    
    struct Server {
        
        let baseURL: String                     // server url
        
        
        init(type: BuildType = .test) {
            switch type {
            case .test:
                baseURL = "http://api.sesac.co.kr:1207"
                
            case .real:
                baseURL = " "
            }
        }
    }

}
