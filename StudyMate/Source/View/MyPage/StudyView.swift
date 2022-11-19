//
//  StudyView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


final class StudyView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let stduyTextField = LineTextFieldView()
    
    
    /// Lfie Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "자주하는 스터디"
        
        stduyTextField.textField.placeholder = "스터디를 입력해 주세요."
        stduyTextField.textField.textAlignment = .left
        
    }
    
    override func setupLayout() {
        [titleLabel, stduyTextField].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        stduyTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
}
