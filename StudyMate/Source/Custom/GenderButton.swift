//
//  GenderButton.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/23.
//

import UIKit

import SnapKit


enum Gender: Int {
    case all = 2
    case man = 1
    case woman = 0
    
    var title: String {
        switch self {
        case .all: return "전체"
        case .man: return "남자"
        case .woman: return "여자"
        }
    }
}


final class GenderButton: UIButton {
    
    /// Initialization
    init(type: Gender) {
        super.init(frame: .zero)
        self.setupAttribute(type: type)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Custom Func
    func setupAttribute(type: Gender) {
        setTitle(type.title, for: .normal)
        titleLabel?.font = UIFont(name: Font.Title4_R14.fontType, size: Font.Title4_R14.fontSize)
        setTitleColor(Color.BaseColor.black, for: .normal)
        backgroundColor = Color.BaseColor.white
    }
    
    func ButtonisSelected(value: Bool) {
        if value {
            titleLabel?.font = UIFont(name: Font.Title4_R14.fontType, size: Font.Title4_R14.fontSize)
            setTitleColor(Color.BaseColor.white, for: .normal)
            backgroundColor = Color.BaseColor.green
        }
        else {
            titleLabel?.font = UIFont(name: Font.Title4_R14.fontType, size: Font.Title4_R14.fontSize)
            setTitleColor(Color.BaseColor.black, for: .normal)
            backgroundColor = Color.BaseColor.white
        }
    }
    
}

