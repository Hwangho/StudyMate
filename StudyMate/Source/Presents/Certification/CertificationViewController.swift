//
//  CertificationViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import SnapKit


class CertificationViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    var titleLabel = LineHeightLabel()
    
    lazy var textFieldView = SignUpTextFieldView(type: type)
    
    lazy var DoneButton = SelectButton(type: .disable, title: type.buttonTitle)
    
    
    /// variable
    var coordinator: CertificationCoordinator?
    
    let type: Certification
    
    
    /// initialization
    init(type: Certification) {
        self.type = type
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
        textFieldView.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textFieldView.textField.resignFirstResponder()
        removeKeyboardNotifications()
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.showsVerticalScrollIndicator = false
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
        
        [titleLabel, textFieldView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(110)
        }
        
        textFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(16)
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
    
    
    private func setupGestureRecognizer() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
      view.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
      view.endEditing(true)
    }
    
}


class SignUpTextFieldView: BaseView {
    
    /// UI
    let textField = UITextField()
    
    let lineView = UIView()
    
    let type: Certification
    
    init(type: Certification) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        lineView.backgroundColor = Color.BaseColor.gray3
        textField.placeholder = type.placholder
        textField.setupFont(type: .Title4_R14)
    }
    
    override func setupLayout() {
        [textField, lineView].forEach {
            addSubview($0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setupFocusTextField() {
        
    }

    
}

// MARK: - keyBoard 관련
extension CertificationViewController {
    
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
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight-16)
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
