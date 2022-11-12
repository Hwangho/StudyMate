//
//  EmailViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class EmailViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackVoew = UIView()
    
    var titleLabel = LineHeightLabel()
    
    lazy var enmailTextFieldView = LineTextFieldView()
    
    lazy var DoneButton = SelectButton(type: .disable, title: "다음")
    
    
    /// variable
    var coordinator: EmailCoordinator?
    
    let viewModel: CertificationViewModel

    
    
    /// initialization
    init(viewModel: CertificationViewModel = CertificationViewModel()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
    }
    
    override func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(view)
            make.width.height.equalTo(view)
        }
        
        
        titleBackVoew.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        contentView.addSubview(titleBackVoew)
        titleBackVoew.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(222.0/812.0)
        }
        
        contentView.addSubview(enmailTextFieldView)
        enmailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleBackVoew.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        view.addSubview(DoneButton)
        DoneButton.snp.makeConstraints { make in
            make.top.equalTo(enmailTextFieldView.snp.bottom).offset(72)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setData() {
        titleLabel.text = "이메일을 입력해 주세요"
        enmailTextFieldView.textField.placeholder = "SeSAC@email.com"
    }
    
    override func setupBinding() {
        /// Action
        DoneButton.rx.tap
            .bind{ [weak self] in
                self?.coordinator?.startGender()
            }
            .disposed(by: disposeBag)
        
        
        /// State
        
    }
    
}
