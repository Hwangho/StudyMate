//
//  CardReviewCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


class CardReviewCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    let reviewLabel = LineHeightLabel()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        reviewLabel.numberOfLines = 0
        reviewLabel.textColor = Color.BaseColor.black
        reviewLabel.setupFont(type: .Body3_R14)
    }
    
    override func setupLayout() {
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// Custom func
    func configure(review: String) {
        if review.isEmpty {
            reviewLabel.text = "첫 리뷰를 기다리는 중이에요!"
            reviewLabel.textColor = Color.BaseColor.gray6
        } else {
            reviewLabel.text = review
        }
    }
}
