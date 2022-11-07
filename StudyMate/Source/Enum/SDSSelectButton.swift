//
//  SDSSelectButton.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit


@frozen
enum SDSSelectButton {
    case inactive
    case fill
    case outline
    case cancel
    case disable
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive: return Color.BaseColor.white
        case .fill: return Color.BaseColor.green
        case .outline: return Color.BaseColor.white
        case .cancel: return Color.BaseColor.gray2
        case .disable: return Color.BaseColor.gray6
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .inactive: return Color.BaseColor.black
        case .fill: return Color.BaseColor.white
        case .outline: return Color.BaseColor.green
        case .cancel: return Color.BaseColor.black
        case .disable: return Color.BaseColor.gray3
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .inactive: return Color.BaseColor.gray4.cgColor
        case .outline: return Color.BaseColor.green.cgColor
        default: return nil
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .inactive, .outline: return 1
        default: return 0
        }
    }
    
}
