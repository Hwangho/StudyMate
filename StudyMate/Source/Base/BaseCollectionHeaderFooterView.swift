//
//  BaseCollectionHeaderFooterView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/18.
//

import UIKit

class BaseCollectionHeaderFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     code로 Layout 잡을 때 해당 함수 내부에서 작성
     */
    func setupLayout() {
        // Override Layout
    }
    
    /**
     기본 속성(Attributes) 관련 정보 (ex Background Color,  Font Color ...)
     */
    func setupAttributes() {
        // Override Attributes
        backgroundColor = Color.BaseColor.white
    }
}
