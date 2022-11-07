//
//  keywordButton.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit


final class keywordButton: UIButton {
    
    /// Initialization
    init(type: SDSSelectButton, showDeleteImage: Bool) {
        super.init(frame: .zero)
        setupAttribute(type: type, showDeleteImage: showDeleteImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// Custom Func
    private func setupAttribute(type: SDSSelectButton, showDeleteImage: Bool) {
        backgroundColor = type.backgroundColor
        layer.borderColor = type.borderColor
        layer.borderWidth = type.borderWidth
        
        if showDeleteImage {
            semanticContentAttribute = .forceRightToLeft
            setImage(UIImage(systemName: "close_small"), for: .normal)
        }
    }
    
}
