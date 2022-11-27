//
//  SearchallowView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


protocol SendSearchAllowProtocool {
    func sendSearchAllow(allow: Int)
}

final class SearchallowView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let switchButton = UISwitch()
    
    var delegate: SendSearchAllowProtocool?
    
    var disposeBag = DisposeBag()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "내 번호 검색 허용"
    }
    
    override func setupLayout() {
        [titleLabel, switchButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        switchButton.rx.isOn
            .bind { [weak self] value in
                self?.delegate?.sendSearchAllow(allow: value ? 1 : 0)
            }
            .disposed(by: disposeBag)
    }
    
    
    /// Custom Func
    func configure(allow: Int) {
        switchButton.isOn = allow == 0 ?  false : true
    }
}
