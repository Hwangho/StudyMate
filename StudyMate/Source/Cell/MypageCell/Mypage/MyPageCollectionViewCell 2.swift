//
//  MyPageCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import SnapKit


final class MyPageCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let titleImage = UIImageView()
    
    private let titleLabel = LineHeightLabel()
    
    private let arrowImage = UIImageView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleImage.contentMode = .scaleAspectFit
        
        titleLabel.setupFont(type: .Title1_M16)
        
        arrowImage.image = UIImage(named: "more_arrow")
    }
    
    override func setupLayout() {
        [titleImage, titleLabel, arrowImage].forEach {
            contentView.addSubview($0)
        }
        
        titleImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(titleImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleImage.snp.centerY)
            make.leading.equalTo(titleImage.snp.trailing).offset(12)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    
    /// Custom Func
    func Configure(value: String) {
        titleLabel.text = value
        titleImage.image = UIImage(named: "notice")
    }
}
