//
//  MyInfoCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class MyInfoCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let stackView = UIStackView()
    
    private let genderView = GenderView()
    
    private let studyView = StudyView()
    
    private let searchallowView = SearchallowView()
    
    private let ageView = AgeView()
    
    private let withDrawView = WithDrawView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        
        stackView.axis = .vertical
    }
    
    override func setupLayout() {
        [genderView, studyView, searchallowView, ageView, withDrawView].forEach {
            stackView.addArrangedSubview($0)
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configure() {
        
    }
    
}
