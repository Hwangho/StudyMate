//
//  GenderCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import UIKit

import SnapKit


final class GenderCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private var titleImage = UIImageView()
    
    private var titleLabel = LineHeightLabel()
    
    override var isSelected: Bool {
          willSet {
              if newValue {
                  contentView.backgroundColor = Color.BaseColor.whitegreen
                  contentView.layer.borderColor = UIColor.clear.cgColor
              } else {
                  contentView.backgroundColor = Color.BaseColor.white
                  contentView.layer.borderColor = Color.BaseColor.gray3.cgColor
              }
          }
      }
    
    
    /// Life Cycle
    override func setupAttributes() {
        titleLabel.setupFont(type: .Title2_R16)
        titleLabel.textAlignment = .center
        
        titleImage.contentMode = .scaleAspectFit
        
        contentView.layer.borderColor = Color.BaseColor.gray3.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }
    
    override func setupLayout() {
        [titleLabel, titleImage].forEach {
            contentView.addSubview($0)
        }
        
        titleImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(64.0/160.0)
            make.height.equalTo(titleImage.snp.width).multipliedBy(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).inset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    
    /// Custom Func
    func setConfigure(type: GenderViewController.Item) {
        titleImage.image = UIImage(named: type.titleImage)
        titleLabel.text = type.titleLabel
    }
    
}

