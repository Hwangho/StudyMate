//
//  LineHeightLabel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class LineHeightLabel: UILabel {
    
    /// Custom Func
    func setupFont(type: Font) {
        font = UIFont(name: type.fontType, size: type.fontSize)
        
        let lineSpacing = type.fontSize * type.lineHeightRate/100
        addLineSpacing(spacing: lineSpacing)
    }
    
    func setupFont(siez: CGFloat, lineHeight: CGFloat) {
        font = UIFont(name: Font.Title1_M16.fontType, size: siez)
        addLineSpacing(spacing: lineHeight)
    }
}
