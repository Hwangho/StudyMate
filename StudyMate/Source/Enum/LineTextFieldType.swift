//
//  LineTextFieldType.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import Foundation


enum LineTextFieldType {
    case inputphoneNumber
    case nickName
    case email
    
    var placholder: String {
        switch self {
        case .inputphoneNumber: return "휴대폰 번호(-없이 숫자만 입력)"
        case .nickName: return "10자 이내로 입력"
        case .email: return "SeSAC@email.com"
        
        }
    }
}
