//
//  OnBoardingCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import SnapKit


final class OnBoardingCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private var titleLabel = LineHeightLabel()
    
    private var titleImage = UIImageView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        titleLabel.setupFont(siez: 24, lineHeight: 38.4)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        titleImage.contentMode = .scaleAspectFit
    }
    
    override func setupLayout() {
        [titleLabel, titleImage].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
        }
        
        titleImage.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(titleImage.snp.width).multipliedBy(1)
        }
    }
    
    
    /// Custom Func
    func setConfigure(type: OnBoardingViewController.Item) {
        titleLabel.text = type.titleLabel
        let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: Color.BaseColor.green, range: (titleLabel.text! as NSString).range(of: "위치 기반"))
        attributedStr.addAttribute(.foregroundColor, value: Color.BaseColor.green, range: (titleLabel.text! as NSString).range(of: "스터디를 원하는 친구"))
        titleLabel.attributedText = attributedStr
        
        titleImage.image = UIImage(named: type.titleImage)
    }
    
}

