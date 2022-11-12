//
//  CertificationTextFieldView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import UIKit

import SnapKit


class CertificationTextFieldView: BaseView {
    
    /// UI
    let textField = UITextField()
    
    let lineView = UIView()
    
    let backView = UIView()
    
    let countLabel = LineHeightLabel()
    
    let reSendButton = SelectButton(type: .fill, title: "재전송")
    
    let stackView = UIStackView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        textField.setupFont(type: .Title4_R14)
        textField.keyboardType = .numberPad
        
        countLabel.setupFont(type: .Title3_M14)
        countLabel.textColor = Color.BaseColor.green
        countLabel.text = "00:00"
        
        lineView.backgroundColor = Color.BaseColor.gray3
        
        stackView.axis = .horizontal
        stackView.spacing = 8
    }
    
    override func setupLayout() {
        [textField, lineView, countLabel].forEach {
            backView.addSubview($0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        countLabel.snp.makeConstraints{ make in
            make.leading.greaterThanOrEqualTo(textField.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(textField.snp.centerY)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        [backView, reSendButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        reSendButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    /// Custom Function
    func focusTexField(value: Bool) {
        lineView.backgroundColor = value ? Color.BaseColor.focus : Color.BaseColor.gray3
    }

}


