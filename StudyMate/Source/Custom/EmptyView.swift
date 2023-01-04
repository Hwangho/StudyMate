//
//  EmptyView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/02.
//

import UIKit

import SnapKit


class EmptyView: BaseView {
    
    private let backView = UIView()
    
    private let imageView = UIImageView()
    
    private let titleLabel = LineHeightLabel()
    
    private let contentLabel = LineHeightLabel()
    
    private let refreshStackview = UIStackView()
    
    let changeStudyButton = SelectButton(type: .fill, title: "스터디 변경하기")
    
    let refreshButton = UIButton()
    
    
    /// initialization
    init(type: LookupStudyViewController.StudyType) {
        super.init(frame: .zero)
        confiigure(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        
        imageView.image = UIImage(named: "empty")
        titleLabel.setupFont(type: .Display1_R20)
        contentLabel.setupFont(type: .Title4_R14)
        
        refreshButton.setImage(UIImage(named: "refresh-line"), for: .normal)
        refreshButton.layer.cornerRadius = 8
        refreshButton.layer.borderColor = Color.BaseColor.green.cgColor
        refreshButton.layer.borderWidth = 1
        
        refreshStackview.axis = .horizontal
        refreshStackview.spacing = 8
    }
    
    override func setupLayout() {
        [imageView, titleLabel, contentLabel].forEach {
            backView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        [changeStudyButton, refreshButton].forEach {
            refreshStackview.addArrangedSubview($0)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
        
        [backView, refreshStackview].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        refreshStackview.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    func confiigure(type: LookupStudyViewController.StudyType) {
        titleLabel.text = type.title
        contentLabel.text = type.content
    }
}
