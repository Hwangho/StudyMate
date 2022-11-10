//
//  CertificationViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class CertificationViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackVoew = UIView()
    
    var titleLabel = LineHeightLabel()
    
    lazy var phonNumberTextFieldView = LineTextFieldView(type: .inputphoneNumber)
    
    lazy var NumberTextFieldView = CertificationTextFieldView()
    
    lazy var DoneButton = SelectButton(type: .disable, title: type.buttonTitle)
    
    
    /// variable
    var coordinator: CertificationCoordinator?
    
    let type: Certification
    
    let viewModel: CertificationViewModel
    
    
    /// initialization
    init(type: Certification, viewModel: CertificationViewModel = CertificationViewModel()) {
        self.type = type
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch type {
        case .phoneNumber:
            phonNumberTextFieldView.textField.becomeFirstResponder()
        case .certificationNumber:
            NumberTextFieldView.textField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        switch type {
        case .phoneNumber:
            phonNumberTextFieldView.textField.resignFirstResponder()
        case .certificationNumber:
            NumberTextFieldView.textField.resignFirstResponder()
        }
        
        removeKeyboardNotifications()
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
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
        
        
        titleBackVoew.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        contentView.addSubview(titleBackVoew)
        titleBackVoew.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(222.0/812.0)
        }
        
        switch type {
        case .phoneNumber:
            contentView.addSubview(phonNumberTextFieldView)
            phonNumberTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(titleBackVoew.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
        case .certificationNumber:
            contentView.addSubview(NumberTextFieldView)
            NumberTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(titleBackVoew.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
        }
        
        view.addSubview(DoneButton)
        DoneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setData() {
        titleLabel.text = type.labeltitle
    }
    
    override func setupBinding() {
        
        switch type {
        case .phoneNumber:
            /// Action
            phonNumberTextFieldView.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .map{
                    CertificationViewModel.Action.inputText(.phoneNumber, $0.applyoriginalPhoneNumber()) }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
            
            phonNumberTextFieldView.textField.rx.controlEvent(.editingDidBegin)
                .map { true }
                .bind { [weak self] value in
                    self?.phonNumberTextFieldView.focusTexField(value: value)}
                .disposed(by: disposeBag)
            
            phonNumberTextFieldView.textField.rx.controlEvent(.editingDidEnd)
                .map { false }
                .bind { [weak self] value in
                    self?.phonNumberTextFieldView.focusTexField(value: value)}
                .disposed(by: disposeBag)
            
            DoneButton.rx.tap
                .map {
                    CertificationViewModel.Action.doneButton(.phoneNumber) }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
            
            /// State            
            viewModel.currentStore
                .map { $0.checkNumberValid }
                .distinctUntilChanged()
                .bind { [weak self] value in
                    let type: SDSSelectButton = value ? .fill : .disable
                    self?.DoneButton.setupAttribute(type: type)}
                .disposed(by: disposeBag)
                
            viewModel.currentStore
                .map{ $0.phoneNumber }
                .bind { [weak self] text in
                    guard let text = text else { return }
                    self?.phonNumberTextFieldView.textField.text = text.applyPatternOnNumbers()
                }
                .disposed(by: disposeBag)
            
            viewModel.currentStore
                .distinctUntilChanged{ $0.checkReciveMessage }
                .map{ $0.checkReciveMessage }
                .subscribe { [weak self] istrue in
                    if istrue {
                        self?.coordinator!.nextCertification(type: .certificationNumber)
                    }
                }
                .disposed(by: disposeBag)

        case .certificationNumber:
            /// Action
            NumberTextFieldView.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .map{
                    CertificationViewModel.Action.inputText(.certificationNumber, $0) }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
            
            NumberTextFieldView.textField.rx.controlEvent(.editingDidBegin)
                .map { true }
                .bind { [weak self] value in
                    self?.NumberTextFieldView.focusTexField(value: value)}
                .disposed(by: disposeBag)
            
            NumberTextFieldView.textField.rx.controlEvent(.editingDidEnd)
                .map { false }
                .bind { [weak self] value in
                    self?.NumberTextFieldView.focusTexField(value: value)}
                .disposed(by: disposeBag)
            
            DoneButton.rx.tap
                .map { CertificationViewModel.Action.doneButton(.certificationNumber) }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
            
            /// State
            viewModel.currentStore
                .map { $0.checkNumberValid }
                .bind { [weak self] value in
                    let type: SDSSelectButton = value ? .fill : .disable
                    self?.DoneButton.setupAttribute(type: type)}
                .disposed(by: disposeBag)
                
            viewModel.currentStore
                .map { $0.certificationNumber }
                .bind { [weak self] text in
                    guard let text = text else { return }
                    self?.NumberTextFieldView.textField.text = text
                }
                .disposed(by: disposeBag)
        }
    }

}


// MARK: - keyBoard 관련
extension CertificationViewController {
    
    private func setupGestureRecognizer() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
      view.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
      view.endEditing(true)
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 0) {
                self.DoneButton.frame.origin.y -= keyboardHeight
                self.DoneButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
                }
            } completion: { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0) {
                self.DoneButton.frame.origin.y += keyboardHeight
                self.DoneButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
                }
            } completion: { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
