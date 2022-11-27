//
//  SearchCollectionviewHeaderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/27.
//

import UIKit

import SnapKit


final class SearchCollectionviewHeaderView: BaseCollectionHeaderFooterView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title6_R12)
        titleLabel.textColor = Color.BaseColor.black
        titleLabel.textAlignment = .left
    }
    
    override func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// Custom Func
    func configure(title: String) {
        titleLabel.text = title
    }
}
