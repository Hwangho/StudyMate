//
//  ServerError.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import Foundation

enum ServerWrapper: Int, Error {
    
    case error
    // 전화 인증 관련 error
    case certificationNumber = 17044
    
    // 로그인 관련 error
    case successed = 200
    case alreadySignupError = 201
    case nickNameError = 202
    case FireBaseToken = 401
    case noneSignup = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .certificationNumber: return "인증번호를 잘못 입력하셨습니다."
        
        case .successed: return "성공"
        case .alreadySignupError: return "이미 가입되어있습니다."
        case .nickNameError: return "사용 불가능한 닉네임입니다."
        case .FireBaseToken: return "FireBase IDToken 갱신해야 될듯"
        case .noneSignup: return "아직 가입 안된 상태"
        case .serverError: return "Server에 문제가 생겼나봐요..."
        case .clientError: return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
            
        default:
            return "error가 발생하였습니다."
        }
    }
    
}
