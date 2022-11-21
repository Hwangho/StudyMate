//
//  StudyView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift


protocol SendStudyProtocool {
    func sendStudy(study: String?)
}


final class StudyView: BaseView {
    
    /// UI
    private let titleLabel = LineHeightLabel()
    
    private let studyTextField = LineTextFieldView()
    
    var delegate: SendStudyProtocool?
    
    var disposeBag = DisposeBag()
    
    /// Lfie Cycle
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.setupFont(type: .Title4_R14)
        titleLabel.text = "자주하는 스터디"
        
        studyTextField.textField.placeholder = "스터디를 입력해 주세요."
        studyTextField.textField.textAlignment = .left
        
    }

    override func setupBinding() {
        studyTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { [weak self] study in
                self?.delegate?.sendStudy(study: study)
            }
            .disposed(by: disposeBag)
    }
    
    
    override func setupLayout() {
        [titleLabel, studyTextField].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(21)
            make.leading.equalToSuperview()
        }
        
        studyTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
    
    func configure(study: String) {
        studyTextField.textField.text = study
    }
}
