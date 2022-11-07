//
//  Theme.swift
//  MemoNote
//
//  Created by 송황호 on 2022/08/31.
//

import UIKit


enum Theme: Int {
    case device
    case light
    case dark
    
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor.black
        default:
            return UIColor.white
        }
    }
    
    var tabbarColor: UIColor {
        switch self {
        case .dark:
            return #colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)
        default:
            return UIColor.white
        }
    }
    
    var tableViewCellColor: UIColor {
        switch self {
        case .dark:
            return #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
        default:
            return UIColor.white
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .dark:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
    var contentColor: UIColor {
        switch self {
        default:
            return UIColor.gray
        }
    }
    
    var highlightColor: UIColor {
        switch self {
        default:
            return UIColor.orange
        }
    }
    
}
