//
//  CardReputationCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


final class CardReputationCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private var titleLabel = LineHeightLabel()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.textAlignment = .center
        titleLabel.setupFont(type: .Title4_R14)
    }
    
    override func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func studyConfigure(title: String, count: Int) {
        let type: SDSSelectButton = count > 0 ? .fill : .inactive
        setViewAttribute(type: type)
        titleLabel.text = title
    }
    
    func titleConfigure(title: String) {
        titleLabel.text = title
        setViewAttribute(type: .inactive)
    }
    
    /// Custom Func
    func setViewAttribute(type: SDSSelectButton) {
        titleLabel.textColor = type.textColor
        contentView.backgroundColor = type.backgroundColor
        contentView.layer.borderColor = type.borderColor
        contentView.layer.borderWidth = type.borderWidth
        contentView.layer.cornerRadius = 8
    }
    
}
