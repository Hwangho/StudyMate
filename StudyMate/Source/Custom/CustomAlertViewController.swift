//
//  CustomAlertViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//

import UIKit

import SnapKit


protocol CustomAlertActionProtocool {
    func tapCancel()
    func tapConfirm()
}


class CustomAlertViewController: BaseViewController {
    
    /// UI
    private let alertView = UIView()
    
    private let textLabel = LineHeightLabel()
    
    private let contentLabel = LineHeightLabel()
    
    private let titleVerticalStackView = UIStackView()
    
    private let cancelButton = UIButton()
    
    private let confirmButton = UIButton()
    
    private let horizontalStackView = UIStackView()
    
    private let verticalStackView = UIStackView()
    
    
    /// properties
    var alertTitleText: String?
    
    var alertContentText: String?
    
    var cancelButtonText: String?
    
    var confirmButtonText: String?
    
    weak var coordinator: CustomAlertCoordinator?
    
    var delegate: CustomAlertActionProtocool?

    
    /// Life Cylce
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = Color.BaseColor.black.withAlphaComponent(0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = .clear
        
        alertView.layer.cornerRadius = 16
        alertView.backgroundColor = Color.BaseColor.white
        
        textLabel.setupFont(type: .Body1_M16)
        textLabel.textColor = Color.BaseColor.black
        textLabel.text = alertTitleText
        textLabel.textAlignment = .center
        
        contentLabel.setupFont(type: .Title4_R14)
        contentLabel.textColor = Color.BaseColor.black
        contentLabel.numberOfLines = 0
        contentLabel.text = alertContentText
        contentLabel.textAlignment = .center
        
        titleVerticalStackView.axis = .vertical
        titleVerticalStackView.spacing = 9
        
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.backgroundColor = Color.BaseColor.gray2
        cancelButton.setTitleColor(Color.BaseColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Font.Body3_R14.fontType, size: Font.Body3_R14.fontSize)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        
        confirmButton.setTitle(confirmButtonText, for: .normal)
        confirmButton.backgroundColor = Color.BaseColor.green
        confirmButton.setTitleColor(Color.BaseColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: Font.Body3_R14.fontType, size: Font.Body3_R14.fontSize)
        confirmButton.layer.cornerRadius = 8
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 8
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 16
    }
    
    override func setupLayout() {
        [textLabel, contentLabel].forEach {
            titleVerticalStackView.addArrangedSubview($0)
        }
                
        [cancelButton, confirmButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
        [titleVerticalStackView, horizontalStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        alertView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.greaterThanOrEqualTo(alertView.snp.width).multipliedBy(156.0/343.0)
        }
    }
    
    func configure(alertTitleText: String , alertContentText: String, cancelButtonText: String = "취소", confirmButtonText: String = "확인") {
        self.alertTitleText = alertTitleText
        self.alertContentText = alertContentText
        self.cancelButtonText = cancelButtonText
        self.confirmButtonText = confirmButtonText
    }
    
    @objc
    func tapCancelButton() {
        delegate?.tapCancel()
    }

    @objc
    func tapConfirmButton() {
        delegate?.tapConfirm()
    }
}
