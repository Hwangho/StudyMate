//
//  CertificationViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa


class CertificationViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackVoew = UIView()
    
    var titleLabel = LineHeightLabel()
    
    lazy var phonNumberTextFieldView = LineTextFieldView()
    
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
    
    
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        switch type {
        case .phoneNumber:
            phonNumberTextFieldView.textField.keyboardType = .phonePad
            phonNumberTextFieldView.textField.placeholder = type.placholder
        case .certificationNumber:
            NumberTextFieldView.textField.keyboardType = .numberPad
            NumberTextFieldView.textField.placeholder = type.placholder
        }
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
        
        view.addSubview(DoneButton)
        
        switch type {
        case .phoneNumber:
            contentView.addSubview(phonNumberTextFieldView)
            phonNumberTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(titleBackVoew.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            DoneButton.snp.makeConstraints { make in
                make.top.equalTo(phonNumberTextFieldView.snp.bottom).offset(72)
                make.width.equalToSuperview().multipliedBy(343.0/375.0)
                make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
                make.centerX.equalToSuperview()
            }
            
        case .certificationNumber:
            contentView.addSubview(NumberTextFieldView)
            NumberTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(titleBackVoew.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            DoneButton.snp.makeConstraints { make in
                make.top.equalTo(NumberTextFieldView.snp.bottom).offset(72)
                make.width.equalToSuperview().multipliedBy(343.0/375.0)
                make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
                make.centerX.equalToSuperview()
            }
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
                .map{ CertificationViewModel.Action.inputText(.phoneNumber, $0.applyoriginalPhoneNumber()) }
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
            
//            DoneButton.rx.tap
//                .map { CertificationViewModel.Action.doneButton(.phoneNumber) }
//                .bind(to: viewModel.action)
//                .disposed(by: disposeBag)
            
            DoneButton.rx.tap
                .bind{ [weak self] in
                    var value = self?.viewModel.store.phoneNumber
                    value?.removeFirst()
                    let phoneNumber = "+82" + (value ?? "")

                    PhoneAuthProvider.provider().verifyPhoneNumber("+1 650-555-1111", uiDelegate: nil) { verificationID, error in
                        if let error = error {
                            // 여기서 error handling
                            print(error)
                        }

                        if let verificationID = verificationID {
                            LocalUserDefaults.shared.set(key: .verificationID, value: verificationID)
                            self?.coordinator!.nextCertification(type: .certificationNumber)
                        }
                    }
                }
                .disposed(by: disposeBag)
            
            
            /// State
            viewModel.currentStore
                .map { $0.checkNumberValid }
                .bind { [weak self] value in
                    let type: SDSSelectButton = value ? .fill : .disable
                    self?.DoneButton.setupAttribute(type: type)
                    self?.DoneButton.isEnabled = value
                }
                .disposed(by: disposeBag)
            
            
            viewModel.currentStore
                .map{ $0.phoneNumber }
                .bind { [weak self] text in
                    guard let text = text else { return }
                    self?.phonNumberTextFieldView.textField.text = text.applyPatternOnNumbers()
                }
                .disposed(by: disposeBag)
            
//            viewModel.currentStore
//                .distinctUntilChanged{ $0.checkReciveMessage }
//                .map{ $0.checkReciveMessage }
//                .subscribe { [weak self] istrue in
//                    if istrue {
//                        self?.coordinator!.nextCertification(type: .certificationNumber)
//                    }
//                }
//                .disposed(by: disposeBag)
            
//            viewModel.currentStore
//                .map { $0.checkReciveMessage }
//                .subscribe { <#Single<String>?#> in
//                    <#code#>
//                } onError: { <#Error#> in
//                    <#code#>
//                } onCompleted: {
//                    <#code#>
//                } onDisposed: {
//                    <#code#>
//                }

            
            
//            viewModel.currentStore
//                .distinctUntilChanged { $0.checkReciveMessage }
//                .map { $0.checkReciveMessage }
//                .subscribe { value in
//                    switch value {
//                    case .success(let value):
//                        print("성공")
//                    case .error(let error):
//                        print("error")
//                    }
//                }
        
            
        case .certificationNumber:
            /// Action
            NumberTextFieldView.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .map{ CertificationViewModel.Action.inputText(.certificationNumber, $0) }
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
            
            DoneButton.rx.tap
                .bind { [weak self] in
                    /// 인증번호 누르고 입력!!
                    
                    let verificationID: String? = LocalUserDefaults.shared.value(key: .verificationID)
                    
                    let credential = PhoneAuthProvider.provider().credential(
                        withVerificationID: verificationID!,
                        verificationCode: (self?.viewModel.store.certificationNumber)!
                    )
                    
                    Auth.auth().signIn(with: credential) { authData, error in
                        
                        if let error = error {
                            guard let errorCode = (error as? NSError)?.code else {return}
                            print("errorCode: \(errorCode)")
                        }
                        
                        print(authData)
                        
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            LocalUserDefaults.shared.set(key: .FirebaseidToken, value: idToken)
                            
                            print(idToken)
                            
                            self?.viewModel.userservice.signin()
                                .subscribe(onSuccess: { user in
                                    self?.coordinator?.startNickName()
                                }, onFailure: { error in
                                    print(error)
                                })
                                .disposed(by: self!.disposeBag)
                        }
                    }
                }
                .disposed(by: disposeBag)
        
            /// State
            viewModel.currentStore
                .map { $0.checkNumberValid }
                .bind { [weak self] value in
                    let type: SDSSelectButton = value ? .fill : .disable
                    self?.DoneButton.setupAttribute(type: type)
                    self?.DoneButton.isEnabled = value
                }
                .disposed(by: disposeBag)
            
            viewModel.currentStore
                .map { $0.certificationNumber }
                .bind { [weak self] text in
                    guard let text = text else { return }
                    self?.NumberTextFieldView.textField.text = text
                }
                .disposed(by: disposeBag)
            
//            viewModel.currentStore
//                .distinctUntilChanged{ $0.checkCertification }
//                .map{ $0.checkCertification }
//                .subscribe { [weak self] istrue in
//                    if istrue {
//                        self?.coordinator!.startNickName()
//                    }
//                }
//                .disposed(by: disposeBag)
        }
    }
    
}
