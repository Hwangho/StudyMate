//
//  BaseView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//


import UIKit

import FirebaseAuth


class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupLayout()
        setupData()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupData() { }
    
    /**
     code로 Layout 잡을 때 해당 함수 내부에서 작성
     */
    func setupLayout() {
        // Override Layout
    }
    
    /**
     기본 속성(Attributes) 관련 정보 (ex Background Color,  Font Color ...)
     */
    func setupAttributes() {
        // Override Attributes
        backgroundColor = Color.BaseColor.white
    }
    
    /**
    Binding 관련 작업
     */
    func setupBinding() {
        
    }
    
    func fireBaseIDTokenRefresh(handler: (() -> ())?) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print(error)
                return
            }
            LocalUserDefaults.shared.set(key: .FirebaseidToken, value: idToken)
            handler?()
        }
    }
}
