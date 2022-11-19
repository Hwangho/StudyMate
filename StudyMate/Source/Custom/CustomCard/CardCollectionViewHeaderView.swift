//
//  CardCollectionViewHeaderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


class CardCollectionViewHeaderView: BaseCollectionHeaderFooterView {
    
    /// UI
    let backImageview = UIImageView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        layer.cornerRadius = 8
    }
    
    override func setupLayout() {
        addSubview(backImageview)
        backImageview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure() {
        /// 서버에서 이미지 받아와야 함!! ( Kingfisher 말고 직접 캐쉬해서 저장 처리 해보자구~!!!! )
        backImageview.image = UIImage(named: "onboarding_img3")
    }
}
