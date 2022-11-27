//
//  FilterGenderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/23.
//

import UIKit

import SnapKit


protocol FilterGenderButtonProtocool {
    func tapGender(type: Gender)
}


final class FilterGenderView: BaseView {
    
    /// UI
    private let cornerView = UIView()
    
    private let stackView = UIStackView()
    
    private let allButton = GenderButton(type: .all)
    
    private let manButton = GenderButton(type: .man)
    
    private let womanButton = GenderButton(type: .woman)
    
    var delegate: FilterGenderButtonProtocool?
    
    
    /// Life Cycle
    override func setupAttributes() {
        backgroundColor = .clear
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        allButton.addTarget(self, action: #selector(tapAllButton), for: .touchUpInside)
        manButton.addTarget(self, action: #selector(tapManButton), for: .touchUpInside)
        womanButton.addTarget(self, action: #selector(tapWomanButton), for: .touchUpInside)
        
        cornerView.layer.masksToBounds = true
        cornerView.layer.cornerRadius = 8
        cornerView.backgroundColor = .clear
        
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    override func setupLayout() {
        [allButton, manButton, womanButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        cornerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(cornerView)
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// Custom Func
    func configure(gender: Gender = .all) {
        switch gender {
        case .all:
            allButton.ButtonisSelected(value: true)
            manButton.ButtonisSelected(value: false)
            womanButton.ButtonisSelected(value: false)
            
        case .man:
            allButton.ButtonisSelected(value: false)
            manButton.ButtonisSelected(value: true)
            womanButton.ButtonisSelected(value: false)
            
        case .woman:
            allButton.ButtonisSelected(value: false)
            manButton.ButtonisSelected(value: false)
            womanButton.ButtonisSelected(value: true)
        }
        delegate?.tapGender(type: gender)
    }
    
    @objc
    func tapAllButton() {
        configure(gender: .all)
    }
    
    @objc
    func tapManButton() {
        configure(gender: .man)
    }
    
    @objc
    func tapWomanButton() {
        configure(gender: .woman)
    }
    
}
