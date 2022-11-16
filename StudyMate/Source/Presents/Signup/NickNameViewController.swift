//
//  NickNameViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class NickNameViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackVoew = UIView()
    
    var titleLabel = LineHeightLabel()
    
    lazy var nickNameTextFieldView = LineTextFieldView()
    
    lazy var DoneButton = SelectButton(type: .disable, title: "다음")
    
    
    /// variable
    var coordinator: NickNameCoordinator?
    
    let viewModel: NickNameViewModel
    
    
    /// initialization
    init(viewModel: NickNameViewModel = NickNameViewModel()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
        
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        nickNameTextFieldView.textField.becomeFirstResponder()
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
        
        contentView.addSubview(nickNameTextFieldView)
        nickNameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleBackVoew.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        view.addSubview(DoneButton)
        DoneButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextFieldView.snp.bottom).offset(72)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    
    override func setData() {
        titleLabel.text = "닉네임을 입력해 주세요"
        nickNameTextFieldView.textField.placeholder = "10자 이내로 입력"
    }
    
    
    override func setupBinding() {
        /// Action
        nickNameTextFieldView.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map{ NickNameViewModel.Action.inputText($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        nickNameTextFieldView.textField.rx.controlEvent(.editingDidBegin)
            .map { true }
            .bind { [weak self] value in
                self?.nickNameTextFieldView.focusTexField(value: value)}
            .disposed(by: disposeBag)
        
        nickNameTextFieldView.textField.rx.controlEvent(.editingDidEnd)
            .map { false }
            .bind { [weak self] value in
                self?.nickNameTextFieldView.focusTexField(value: value)}
            .disposed(by: disposeBag)
        
        DoneButton.rx.tap
            .bind{ [weak self] in
                LocalUserDefaults.shared.set(key: .nickName, value: self?.viewModel.store.nickName)
                    self?.coordinator?.startBirth()
            }
            .disposed(by: disposeBag)
        
        /// State
        viewModel.currentStore
            .distinctUntilChanged{$0.checkNickNameValid}
            .map { $0.checkNickNameValid }
            .bind { [weak self] value in
                self?.DoneButton.isEnabled = value
                self?.DoneButton.setupAttribute(type: value ? .fill : .disable)
            }
            .disposed(by: disposeBag)
        
    }
    
}

