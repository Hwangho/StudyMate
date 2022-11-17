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
    
    let titleBackView = UIView()
    
    var titleLabel = LineHeightLabel()
    
    var contentLabel = LineHeightLabel()
    
    lazy var enmailTextFieldView = LineTextFieldView()
    
    lazy var DoneButton = SelectButton(type: .disable, title: "다음")
    
    
    /// variable
    var coordinator: EmailCoordinator?
    
    let viewModel: EmailViewModel
    
    
    /// initialization
    init(viewModel: EmailViewModel = EmailViewModel()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enmailTextFieldView.textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        enmailTextFieldView.textField.resignFirstResponder()
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        contentLabel.setupFont(type: .Title2_R16)
        contentLabel.textColor = Color.BaseColor.gray7
        contentLabel.textAlignment = .center
        
        setupGestureRecognizer()
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
        
        
        [titleLabel, contentLabel].forEach {
            titleBackView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        
        contentView.addSubview(titleBackView)
        titleBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(222.0/812.0)
        }
        
        contentView.addSubview(enmailTextFieldView)
        enmailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom)
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
        contentLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        enmailTextFieldView.textField.placeholder = "SeSAC@email.com"
    }
    
    override func setupBinding() {
        /// Action
        enmailTextFieldView.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { EmailViewModel.Action.inputEmail($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        
        DoneButton.rx.tap
            .bind{ [weak self] in
                LocalUserDefaults.shared.set(key: .email, value: self?.viewModel.store.email)
                self?.coordinator?.startGender()
            }
            .disposed(by: disposeBag)
        
        enmailTextFieldView.textField.rx.controlEvent(.editingDidBegin)
            .map { true }
            .bind { [weak self] value in
                self?.enmailTextFieldView.focusTexField(value: value)}
            .disposed(by: disposeBag)
        
        enmailTextFieldView.textField.rx.controlEvent(.editingDidEnd)
            .map { false }
            .bind { [weak self] value in
                self?.enmailTextFieldView
                .focusTexField(value: value)}
            .disposed(by: disposeBag)
        
        /// State
        viewModel.currentStore
            .map { $0.checEmailValid }
            .bind { [weak self] value in
                self?.DoneButton.ButtonisEnabled(value: value)
            }
            .disposed(by: disposeBag)
    }
    
}
