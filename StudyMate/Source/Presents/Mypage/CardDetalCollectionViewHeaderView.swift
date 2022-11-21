//
//  CardDetalCollectionViewHeaderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


class CardDetalCollectionViewHeaderView: BaseCollectionHeaderFooterView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let moreReviewButton = UIButton()
    
    var coordinator: ChangeMyPageCoordinator?
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        layer.cornerRadius = 8
        
        moreReviewButton.setImage(UIImage(named: "more_arrow"), for: .normal)
        moreReviewButton.isHidden = true
        moreReviewButton.addTarget(self, action: #selector(tapMoreReviewButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        [titleLabel, moreReviewButton].forEach {
            addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
        }
        
        moreReviewButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    
    @objc
    func tapMoreReviewButton() {
        coordinator?.startMoreReview()
    }
    
    func myInfoConfigure(type: CardTypeCollectionView.myInfoSection, reviews: [String]) {
        titleLabel.text = type.rawValue
        titleLabel.textColor = Color.BaseColor.black
        titleLabel.setupFont(type: .Title6_R12)
        
        if type == .review {
            if reviews.count > 1 {
                moreReviewButton.isHidden = false
            }
        }
    }
    
    func searchStudyConfigure(type: CardTypeCollectionView.SearchStudySection) {
        titleLabel.text = type.rawValue
        titleLabel.textColor = Color.BaseColor.black
        titleLabel.setupFont(type: .Title6_R12)
    }
}
