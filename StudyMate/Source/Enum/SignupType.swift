//
//  SignupType.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import Foundation


enum SignupType: Hashable {
    case nickname
    case birth
    case email
    case gender
    
    var labeltitle: String {
        switch self {
        case .nickname: return "닉네임을 입력해 주세요"
        case .birth: return "생년월일을 알려주세요"
        case .email: return "이메일을 입력해 주세요"
        case .gender: return "성별을 선택해 주세요"
        }
    }
    
    var conentTitle: String {
        switch self {
        case .nickname: return ""
        case .birth: return ""
        case .email: return "휴대폰 번호 변경 시 인증을 위해 사용해요"
        case .gender: return "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        }
    }
    
    var buttonTitle: String {
        switch self {
        default: return "다음"
        }
    }
    
}
