//
//  Font.swift
//  MemoNote
//
//  Created by 송황호 on 2022/09/01.
//

import Foundation
import UIKit


enum Font {
        
    case bold
    case light
    case medium
    
    var type: String {
        switch self {
        case .bold: return "GmarketSansBold"
        case .light: return "GmarketSansLight"
        case .medium: return "GmarketSansMedium"
        }
    }
    
    func scaledFont(to size: CGFloat) -> UIFont {
        return UIFont(name: self.type, size: size)!
    }
    
    func scaledFont(size: FontTextSize) -> UIFont {
        return UIFont(name: self.type, size: size.value)!
    }
}


enum FontTextSize {
    case sectionTitle
    case cellTitle
    case cellContent
    case changeMemoText
    
    var value: CGFloat {
        switch self {
        case .sectionTitle: return 23
        case .cellTitle: return 16
        case .cellContent: return 12
        case .changeMemoText: return 15
        }
    }
}
