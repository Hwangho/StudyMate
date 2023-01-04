//
//  CardCollectionViewHeaderView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift

protocol HeaderButtonDelegate: AnyObject {
    func tapStudyButton(type: CardCollectionViewHeaderView.buttonType, uuid: String?)
}


class CardCollectionViewHeaderView: BaseCollectionHeaderFooterView {
    
    /// type
    enum buttonType {
        case none
        case request
        case response
    }
    
    /// properties
    var type: buttonType!
    
    var queueUser: QueueUser?
    
    weak var headerDelegate: HeaderButtonDelegate?
    
    
    /// UI
    private let backgroundImage = UIImageView()
    
    private let sesacImage = UIImageView()
    
    private let studyButton = UIButton()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        layer.cornerRadius = 8
        clipsToBounds = true
        
        studyButton.addTarget(self, action: #selector(tapstudyButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        
        [backgroundImage, sesacImage, studyButton].forEach {
            addSubview($0)
        }
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(-9)
            make.width.equalTo(backgroundImage.snp.width).multipliedBy(184.0/343.0)
            make.height.equalTo(sesacImage.snp.width)
        }
        
        studyButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
    
    @objc
    func tapstudyButton() {
        headerDelegate?.tapStudyButton(type: type, uuid: queueUser?.uid)
    }
    
    /// Custom Func
    func configure(queueUser: QueueUser, type: buttonType) {
        /// 서버에서 이미지 받아와야 함!! ( Kingfisher 말고 직접 캐쉬해서 저장 처리 해보자구~!!!! )
        backgroundImage.image = UIImage(named: queueUser.background)
        sesacImage.image = UIImage(named: queueUser.sesac)
        studyButtonType(type: type)
        self.type = type
        self.queueUser = queueUser
    }
    
    private func studyButtonType(type: buttonType) {
        switch type {
        case .request:
            studyButton.backgroundColor = Color.BaseColor.error
            studyButton.layer.cornerRadius = 8
            studyButton.setTitle("요청하기", for: .normal)
            studyButton.titleLabel?.font = UIFont(name: Font.Title3_M14.fontType, size: Font.Title3_M14.fontSize)
            studyButton.tintColor = Color.BaseColor.white
        case .response:
            studyButton.backgroundColor = Color.BaseColor.success
            studyButton.layer.cornerRadius = 8
            studyButton.setTitle("수락하기", for: .normal)
            studyButton.titleLabel?.font = UIFont(name: Font.Title3_M14.fontType, size: Font.Title3_M14.fontSize)
            studyButton.tintColor = Color.BaseColor.white
            
        case .none:
            studyButton.isHidden = true
        }

    }

}
