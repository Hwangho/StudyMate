//
//  SearchStudyCardCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/30.
//

import UIKit

import SnapKit


class SearchStudyCardCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    let titleStackView = UIStackView()
    
    let nameLabel = UILabel()
    
    let moreImage = UIImageView()
    
    let stackView = UIStackView()

    lazy var cardInfoViewcontroller = CardDetailCollectionViewController(type: .searchStduy)
    
    let padding: CGFloat = 16
    
    
    var unclickContsraint: Constraint?
    
    var clickConstraint: Constraint?
    
    override var isSelected: Bool {
        didSet {
            constraintChange()
        }
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        contentView.layer.borderColor = Color.BaseColor.gray2.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
        stackView.axis = .vertical
        
        moreImage.image = UIImage(named: "card_more_arrow")
                
        clipsToBounds = true
    }
    
    override func setupLayout() {
        
        [nameLabel, moreImage].forEach {
            titleStackView.addArrangedSubview($0)
        }

        [titleStackView, cardInfoViewcontroller.view].forEach {
            stackView.addArrangedSubview($0)
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        

        titleStackView.snp.makeConstraints { make in
            unclickContsraint = make.bottom.equalTo(contentView.snp.bottom).offset(-padding).priority(250).constraint
            make.height.equalTo(20)
        }

        cardInfoViewcontroller.view.snp.makeConstraints { make in
            clickConstraint = make.bottom.equalTo(contentView.snp.bottom).offset(-padding).priority(250).constraint
        }
        
        cardInfoViewcontroller.view.translatesAutoresizingMaskIntoConstraints = false

        clickConstraint?.deactivate()
        unclickContsraint?.activate()
     
    }
    
    func configure(queueUser: QueueUser) {
        nameLabel.text = queueUser.nick
        cardInfoViewcontroller.viewmodel.action.accept(.sendUserData(queueUser))
    }
    
    private func constraintChange() {

        if isSelected {
            clickConstraint?.activate()
            unclickContsraint?.deactivate()
        } else {
            clickConstraint?.deactivate()
            unclickContsraint?.activate()
        }

        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.moreImage.transform = self.isSelected ? upsideDown :.identity
        }
    }
    
}
