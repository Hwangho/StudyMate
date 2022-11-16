//
//  Certification.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import Foundation


enum Certification {
    case phoneNumber
    case certificationNumber
    
    var labeltitle: String {
        switch self {
        case .phoneNumber: return "새싹 서비스 이용을 위해\n 휴대폰 번호를 입력해 주세요"
        case .certificationNumber: return "인증번호가 문자로 전송되었어요"
        }
    }
    
    var placholder: String {
        switch self {
        case .phoneNumber: return "휴대폰 번호(-없이 숫자만 입력)"
        case .certificationNumber: return "인증번호 입력"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .phoneNumber: return "인증 문자 받기"
        case .certificationNumber: return "인증 문자 받기"
        }
    }
    
}
