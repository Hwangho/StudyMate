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
    let titleLabel = LineHeightLabel()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        layer.cornerRadius = 8
    }
    
    override func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
        }
    }
    
    func configure(type: CardDetailCollectionViewController.Section) {
        titleLabel.text = type.rawValue
        titleLabel.textColor = Color.BaseColor.black
        titleLabel.setupFont(type: .Title6_R12)
    }
}
