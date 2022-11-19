//
//  SettingCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import SnapKit


final class SettingCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let lineView = UIView()
    
    private let titleImage = UIImageView()
    
    private let titleLabel = LineHeightLabel()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        lineView.backgroundColor = Color.BaseColor.gray2
        
        titleImage.contentMode = .scaleAspectFit
        
        titleLabel.setupFont(type: .Title2_R16)
    }
    
    override func setupLayout() {
        [lineView, titleImage, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.333)
            make.width.equalTo(titleImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleImage.snp.centerY)
            make.leading.equalTo(titleImage.snp.trailing).offset(12)
        }
    }
    
    
    /// Custom Func
    func Configure(type: MyPageViewController.Setting) {
        titleImage.image = type.image
        titleLabel.text = type.title
    }
}
