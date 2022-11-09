//
//  UITextField+Extension.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import UIKit


extension UITextField {
    
    
    public func addLineSpacing(spacing: CGFloat) {
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = spacing
            style.maximumLineHeight = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    /// Custom Func
    func setupFont(type: Font) {
        font = UIFont(name: type.fontType, size: type.fontSize)
        let lineSpacing = type.fontSize * type.lineHeightRate/100
        addLineSpacing(spacing: lineSpacing)
    }
}
