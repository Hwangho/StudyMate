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
import Moya


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
            
            DoneButton.rx.tap
                .bind{ [weak self] in
                    var value = self?.viewModel.store.phoneNumber
                    value?.removeFirst()
                    let phoneNumber = "+82" + (value ?? "")
                    LocalUserDefaults.shared.set(key: .phoneNumber, value: phoneNumber)
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                        if let error = error {
                            self?.showAlertMessage(title: error.localizedDescription)
                            return
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
                    self?.DoneButton.ButtonisEnabled(value: value)
                }
                .disposed(by: disposeBag)
            
            
            viewModel.currentStore
                .map{ $0.phoneNumber }
                .bind { [weak self] text in
                    guard let text = text else { return }
                    self?.phonNumberTextFieldView.textField.text = text.applyPatternOnNumbers()
                }
                .disposed(by: disposeBag)
            
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
                            let errorCode = (error as NSError).code
                            let type = ServerError.init(rawValue: errorCode) ?? ServerError.error
                            self?.showAlertMessage(title: type.message)
                            return
                        }
                        
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            LocalUserDefaults.shared.set(key: .FirebaseidToken, value: idToken)
                            
                            self?.viewModel.userservice.signin()
                                .subscribe(onSuccess: { _ in
                                    /// 이미 가입 되어 있을 경우!! 로그인 성공
                                    self?.coordinator?.showInitialView(with: .main)
                                }, onFailure: { error in
                                    
                                    let moyaError: MoyaError? = error as? MoyaError
                                    let response : Response? = moyaError?.response
                                    let statusCode : Int? = response?.statusCode
                                    
                                    let type = ServerError.init(rawValue: statusCode!) ?? ServerError.error
                                    switch type {
                                    case .noneSignup:
                                        self?.coordinator?.startNickName()
                                    default:
                                        self?.showAlertMessage(title: type.message)
                                    }
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
                    self?.DoneButton.ButtonisEnabled(value: value)
                }
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
