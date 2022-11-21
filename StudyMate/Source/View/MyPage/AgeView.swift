//
//  AgeView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit

protocol sendAgeProtocool {
    func sendAge(ageMin: Int, ageMax: Int)
}

final class AgeView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let ageLabel = LineHeightLabel()
    
    private let slider = MultiSlider()
    
    var delegate: sendAgeProtocool?
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "상대방 연령대"
        
        ageLabel.setupFont(type: .Title4_R14)
        ageLabel.textColor = Color.BaseColor.green
        
        slider.minValue = 18
        slider.maxValue = 65

        ageLabel.text = "\(Int(slider.lower)) ~ \(Int(slider.upper))"
        slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    override func setupLayout() {
        [titleLabel, ageLabel, slider].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.height.equalTo(22)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(17)
        }
    }
    
    @objc private func changeValue() {
        ageLabel.text = "\(Int(slider.lower)) ~ \(Int(slider.upper))"
        delegate?.sendAge(ageMin: Int(slider.lower), ageMax: Int(slider.upper))
    }
    
    func configure(ageMin: Int, ageMax: Int) {
        slider.lower = Double(ageMin)
        slider.upper = Double(ageMax)
    }
}
