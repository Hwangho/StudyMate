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
    private let backgroundImage = UIImageView()
    
    private let sesacImage = UIImageView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    override func setupLayout() {
        
        [backgroundImage, sesacImage].forEach {
            addSubview($0)
        }
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(-9)
            make.width.equalTo(backgroundImage.snp.width).multipliedBy(184.0/343.0)
            make.height.equalTo(sesacImage.snp.width)
        }
    }
    
    func configure(user: User) {
        /// 서버에서 이미지 받아와야 함!! ( Kingfisher 말고 직접 캐쉬해서 저장 처리 해보자구~!!!! )
        backgroundImage.image = UIImage(named: user.background)
        sesacImage.image = UIImage(named: user.sesac)
    }
}
