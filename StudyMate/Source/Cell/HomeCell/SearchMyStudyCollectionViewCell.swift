//
//  SearchMyStudyCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/27.
//

import UIKit

import SnapKit


final class SearchMyStudyCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let stackview = UIStackView()
    
    private let titleLabel = LineHeightLabel()
    
    private let removeImage = UIImageView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        contentView.layer.borderColor = Color.BaseColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
        stackview.axis = .horizontal
        stackview.spacing = 4
        
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.textColor = Color.BaseColor.black
        titleLabel.numberOfLines = 0
        
        removeImage.image = UIImage(named: "close_small_green")
    }
    
    override func setupLayout() {
        [titleLabel, removeImage].forEach {
            stackview.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(value: String) {
        titleLabel.text = value
        contentView.layer.borderColor = Color.BaseColor.green.cgColor
        titleLabel.textColor = Color.BaseColor.green
    }
    
}
