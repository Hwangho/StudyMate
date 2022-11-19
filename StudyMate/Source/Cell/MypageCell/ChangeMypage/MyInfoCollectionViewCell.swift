//
//  MyInfoCollectionViewCell.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class MyInfoCollectionViewCell: BaseCollectionViewCell {
    
    /// UI
    private let stackView = UIStackView()
    
    private let genderView = GenderView()
    
    private let studyView = StudyView()
    
    private let searchallowView = SearchallowView()
    
    private let ageView = AgeView()
    
    private let withDrawView = WithDrawView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        
        stackView.axis = .vertical
        stackView.spacing = 24
    }
    
    override func setupLayout() {
        [genderView, studyView, searchallowView, ageView, withDrawView].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configure() {
        
    }
    

}



final class GenderView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let manButton = SelectButton(type: .fill, title: "남자")
    
    private let womanButton = SelectButton(type: .inactive, title: "여자")
    
    private let stackView = UIStackView()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "내 성별"
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
    }
    
    override func setupLayout() {
        [manButton, womanButton].forEach {
            stackView.addArrangedSubview($0)
            $0.titleLabel?.font = UIFont(name: Font.Body3_R14.fontType, size: Font.Body3_R14.fontSize)
        }
        
        [titleLabel, stackView].forEach {
            addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    
}




final class StudyView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let stduyTextField = LineTextFieldView()
    
    
    /// Lfie Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "자주하는 스터디"
        
        stduyTextField.textField.placeholder = "스터디를 입력해 주세요."
        stduyTextField.textField.textAlignment = .left
        
    }
    
    override func setupLayout() {
        [titleLabel, stduyTextField].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        stduyTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.trailing.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
}




final class SearchallowView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let switchButton = UISwitch()
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "내 번호 검색 허용"
    }
    
    override func setupLayout() {
        [titleLabel, switchButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }

        
    }
    
}




final class AgeView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let ageLabel = LineHeightLabel()
    
    private let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "상대방 연령대"
        
        ageLabel.setupFont(type: .Title4_R14)
        ageLabel.textColor = Color.BaseColor.green
        ageLabel.text = "asdasd"
        
        configure()
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
    override func setupLayout() {
        [titleLabel, ageLabel, rangeSlider].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        rangeSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(31)
        }
    }
    
    func configure(startTime: Int = 23, endTime: Int = 32) {
        ageLabel.text = "\(startTime) - \(endTime)"
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }
    
}




final class WithDrawView: BaseView {
    
    private let titleLabel = LineHeightLabel()
    
    private let withDraButton = UIButton()
    
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "회원 탈퇴"
        
        withDraButton.setTitle("", for: .normal)
        withDraButton.backgroundColor = .clear
        
        withDraButton.addTarget(self, action: #selector(tapWithdrawButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        [titleLabel, withDraButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        withDraButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    @objc
    func tapWithdrawButton() {
        print("회원 탈퇴")
    }
}
