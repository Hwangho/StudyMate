//
//  CertificationFieldView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import UIKit

import SnapKit


class LineTextFieldView: BaseView {
    
    /// UI
    let textField = UITextField()
    
    let lineView = UIView()
    
    /// variable
    let type: LineTextFieldType
    
    
    /// initialization
    init(type: LineTextFieldType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        lineView.backgroundColor = Color.BaseColor.gray3
        textField.placeholder = type.placholder
        textField.setupFont(type: .Title4_R14)
        
        switch type {
        case .inputphoneNumber:
            textField.keyboardType = .phonePad
        case .nickName:
            print("nucname")
        case .email:
            print("email")
        }
    }
    
    override func setupLayout() {
        [textField, lineView].forEach {
            addSubview($0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
    /// Custom Function
    func focusTexField(value: Bool) {
        lineView.backgroundColor = value ? Color.BaseColor.focus : Color.BaseColor.gray3
    }

}

