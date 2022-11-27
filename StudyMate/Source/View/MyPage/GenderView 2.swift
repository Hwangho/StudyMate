//
//  GenderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit



protocol SendGenderProtocool {
    func sendGender(gender: Int)
}


final class GenderView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let manButton = SelectButton(type: .fill, title: "남자")
    
    private let womanButton = SelectButton(type: .inactive, title: "여자")
    
    private let stackView = UIStackView()
    
    var delegate: SendGenderProtocool?
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "내 성별"
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        manButton.addTarget(self, action: #selector(tapManButton), for: .touchUpInside)
        womanButton.addTarget(self, action: #selector(tapWomanButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        [manButton, womanButton].forEach {
            stackView.addArrangedSubview($0)
            $0.titleLabel?.font = UIFont(name: Font.Body3_R14.fontType, size: Font.Body3_R14.fontSize)
        }
        
        [titleLabel, stackView].forEach {
            addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(9)
            make.trailing.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
    }
    
    
    /// Custom Func
    func configure(gender: Int) {
        manButton.setupAttribute(type: gender == 0 ? .inactive : .fill)
        womanButton.setupAttribute(type: gender == 0 ? .fill : .inactive)
        delegate?.sendGender(gender: gender)
    }
    
    @objc
    func tapManButton() {
        configure(gender: 1)
    }
    
    @objc
    func tapWomanButton() {
        configure(gender: 0)
    }
    
}
