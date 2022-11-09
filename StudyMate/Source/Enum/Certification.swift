//
//  Certification.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import Foundation


enum Certification {
    case inputphoneNumber
    case checkCertification
    
    var labeltitle: String {
        switch self {
        case .inputphoneNumber: return "새싹 서비스 이용을 위해\n 휴대폰 번호를 입력해 주세요"
        case .checkCertification: return "인증번호가 문자로 전송되었어요"
        }
    }
    
    var placholder: String {
        switch self {
        case .inputphoneNumber: return "휴대폰 번호(-없이 숫자만 입력)"
        case .checkCertification: return "인증번호 입력"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .inputphoneNumber: return "인증 문자 받기"
        case .checkCertification: return "인증 문자 받기"
        }
    }
    
    var nextButton: Certification? {
        switch self {
        case .inputphoneNumber: return .checkCertification
        case .checkCertification: return nil
        }
    }
}
