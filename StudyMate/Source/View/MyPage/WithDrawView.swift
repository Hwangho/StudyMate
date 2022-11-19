//
//  WithDrawView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit
import SnapKit


final class WithDrawView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let withDraButton = UIButton()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "회원 탈퇴"
        
        withDraButton.setTitle("", for: .normal)
        withDraButton.backgroundColor = .clear
        
        withDraButton.addTarget(self, action: #selector(tapWithdrawButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        [titleLabel, withDraButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        withDraButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
    @objc
    func tapWithdrawButton() {
        print("회원 탈퇴")
    }
}
