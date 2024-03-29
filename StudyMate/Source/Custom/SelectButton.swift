//
//  SelectButton.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit

import SnapKit


final class SelectButton: UIButton {
    
    /// Initialization
    init(type: SDSSelectButton, title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.setupAttribute(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Custom Func
    func setupAttribute(type: SDSSelectButton) {
        backgroundColor = type.backgroundColor
        layer.borderColor = type.borderColor
        layer.borderWidth = type.borderWidth
        setTitleColor(type.textColor, for: .normal)
        layer.cornerRadius = 8
    }
    
    func ButtonisEnabled(value: Bool) {
        let type: SDSSelectButton = value ? .fill : .disable
        setupAttribute(type: type)
        isEnabled = value
    }
    
}


