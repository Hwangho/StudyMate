//
//  SearchRecomandCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/27.
//

import UIKit

import SnapKit


final class SearchRecomandCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let stackview = UIStackView()
    
    private let titleLabel = LineHeightLabel()
    
    
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
    }
    
    override func setupLayout() {
        [titleLabel].forEach {
            stackview.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(value: RecomandStudys) {
        
        switch value.type {
        case .recomand:
            contentView.layer.borderColor = Color.BaseColor.error.cgColor
            titleLabel.textColor = Color.BaseColor.error
            titleLabel.text = value.title
        case .around:
            contentView.layer.borderColor = Color.BaseColor.gray4.cgColor
            titleLabel.textColor = Color.BaseColor.black
            titleLabel.text = value.title
        }

    }
    
}
