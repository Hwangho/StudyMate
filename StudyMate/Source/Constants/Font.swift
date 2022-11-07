//
//  Font.swift
//  MemoNote
//
//  Created by 송황호 on 2022/09/01.
//

import UIKit


enum Font {
    case Display1_R20
    case Title1_M16
    case Title2_R16
    case Title3_M14
    case Title4_R14
    case Title5_M12
    case Title5_R12
    case Body1_M16
    case Body2_R16
    case Body3_R14
    case Body4_R12
    case caption_R10
    
    
    var setUIFont: UIFont {
        switch self {
        case .Display1_R20: return UIFont(name: "NotoSansKR-Regular", size: 20)!
            
        case .Title1_M16: return UIFont(name:  "NotoSansKR-Medium", size: 16)!
        case .Title2_R16: return UIFont(name: "NotoSansKR-Regular", size: 16)!
        case .Title3_M14: return UIFont(name:  "NotoSansKR-Medium", size: 14)!
        case .Title4_R14: return UIFont(name: "NotoSansKR-Regular", size: 14)!
        case .Title5_M12: return UIFont(name:  "NotoSansKR-Medium", size: 12)!
        case .Title5_R12: return UIFont(name: "NotoSansKR-Regular", size: 12)!
            
        case .Body1_M16: return UIFont(name:  "NotoSansKR-Medium", size: 16)!
        case .Body2_R16: return UIFont(name: "NotoSansKR-Regular", size: 16)!
        case .Body3_R14: return UIFont(name: "NotoSansKR-Regular", size: 12)!
        case .Body4_R12: return UIFont(name: "NotoSansKR-Regular", size: 12)!
            
        case .caption_R10: return UIFont(name: "NotoSansKR-Regular", size: 10)!
        }
    }
    
}
